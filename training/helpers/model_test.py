import sys
from pathlib import Path

import torch
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def check_environment():
    logger.info(f"logger.info PyTorch version: {torch.__version__}")
    logger.info(f"logger.info CUDA available: {torch.cuda.is_available()}")
    if torch.cuda.is_available():
        logger.info("  CUDA detected but not needed for CPU inference")
    else:
        logger.info("logger.info CPU-only setup (perfect for deployment)")

    try:
        import transformers

        logger.info(f"logger.info Transformers version: {transformers.__version__}")
    except ImportError:
        logger.info("logger.infoTransformers not installed!")
        logger.info("   Run: pip install transformers")
        return False

    try:
        import peft

        logger.info(f"logger.info PEFT version: {peft.__version__}")
    except ImportError:
        logger.info("logger.infoPEFT not installed!")
        logger.info("Run: pip install peft")
        return False

    return True


def check_model_files():

    model_path = Path("recipe-bot-finetuned")

    if not model_path.exists():
        logger.info(f"logger.infoModel directory not found: {model_path}")
        logger.info(" Steps to fix:")
        logger.info("   1. Download model from Colab")
        logger.info("   2. Extract to backend/ directory")
        logger.info("   3. Ensure folder name is 'recipe-bot-finetuned-final'")
        return False

    required_files = [
        "adapter_config.json",
        "adapter_model.safetensors",
        "tokenizer_config.json",
        "tokenizer.json",
    ]

    logger.info(f"logger.info Model directory found: {model_path.absolute()}")
    logger.info("Checking required files:")

    all_found = True
    for file in required_files:
        file_path = model_path / file
        if file_path.exists():
            size = file_path.stat().st_size / (1024 * 1024)  # MB
            logger.info(f"   logger.info {file} ({size:.2f} MB)")
        else:
            logger.info(f"   logger.info{file} - MISSING!")
            all_found = False

    return all_found


def test_model_loading():
    try:
        from peft import PeftModel
        from transformers import AutoModelForCausalLM, AutoTokenizer

        logger.info("1Loading tokenizer...")
        base_model_name = "TinyLlama/TinyLlama-1.1B-Chat-v1.0"
        tokenizer = AutoTokenizer.from_pretrained(base_model_name)
        logger.info("   logger.info Tokenizer loaded")

        logger.info("2Loading base model...")
        base_model = AutoModelForCausalLM.from_pretrained(
            base_model_name,
            torch_dtype=torch.float32,
            device_map="cpu",
            low_cpu_mem_usage=True,
        )
        logger.info("   logger.info Base model loaded on CPU")

        logger.info("3Loading LoRA adapters...")
        model = PeftModel.from_pretrained(base_model, "recipe-bot-finetuned")
        logger.info("   logger.info LoRA adapters loaded successfully!")

        # Count parameters
        trainable = sum(p.numel() for p in model.parameters() if p.requires_grad)
        total = sum(p.numel() for p in model.parameters())

        logger.info(" Model Statistics:")
        logger.info(f"Total parameters: {total:,}")
        logger.info(f"Trainable (LoRA): {trainable:,}")
        logger.info(f"Device: {next(model.parameters()).device}")
        logger.info(f"Dtype: {next(model.parameters()).dtype}")

        return model, tokenizer

    except Exception as e:
        logger.info(f"logger.infoError loading model: {e}")
        return None, None


def test_inference(model, tokenizer):

    test_cases = [
        "eggs, onions",
        "tomatoes, pasta",
    ]

    model.eval()
    model.config.use_cache = True

    for ingredients in test_cases:
        logger.info(f"Testing: {ingredients}")
        logger.info("-" * 70)

        prompt = f"""<s>[INST] Suggest a recipe using the following ingredients:
{ingredients} [/INST]"""

        inputs = tokenizer(prompt, return_tensors="pt")

        logger.info("   Generating recipe...")
        import time

        start = time.time()

        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=250,
                temperature=0.7,
                do_sample=True,
                top_p=0.9,
                repetition_penalty=1.2,
                pad_token_id=tokenizer.eos_token_id,
            )

        elapsed = time.time() - start

        full_response = tokenizer.decode(outputs[0], skip_special_tokens=True)

        if "[/INST]" in full_response:
            recipe = full_response.split("[/INST]", 1)[1].strip()
        else:
            recipe = full_response

        logger.info(f"    Generation time: {elapsed:.2f}s")
        logger.info("    Generated Recipe:")
        logger.info("   " + recipe[:300].replace("", "   "))
        if len(recipe) > 300:
            logger.info("   ...")
        logger.info("-" * 70)


def main():

    if not check_environment():
        logger.info("logger.infoEnvironment check failed!")
        logger.info("Please install missing packages and try again.")
        sys.exit(1)

    if not check_model_files():
        logger.info("logger.infoModel files check failed!")
        logger.info("Please download and extract the model first.")
        sys.exit(1)

    model, tokenizer = test_model_loading()
    if model is None:
        logger.info("logger.infoModel loading failed!")
        sys.exit(1)

    test_inference(model, tokenizer)
    logger.info("logger.infoYour model is ready to use!")
    logger.info("Next steps:")
    logger.info("   1. Run: python recipe_bot.py")
    logger.info("   2. Run: python api.py")
    logger.info("   3. Run: streamlit run ../frontend/app.py")


if __name__ == "__main__":
    main()
