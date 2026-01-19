import os
from pathlib import Path

BASE_DIR = Path(__file__).parent.absolute()
PROJECT_DIR = BASE_DIR.parent

RECIPE_BOT_MODEL_PATH = str(PROJECT_DIR / "models" / "recipe-bot-finetuned-v1")
RECIPE_BOT_BASE_MODEL = "TinyLlama/TinyLlama-1.1B-Chat-v1.0"

NAME_MATCHER_MODEL = "sentence-transformers/paraphrase-MiniLM-L3-v2"

DATA_DIR = PROJECT_DIR / "data"
NAMES_DATA_PATH = DATA_DIR / "names.json"
RECIPES_DATA_PATH = DATA_DIR / "recipes.json"
RECIPES_TRAINING_DATA_PATH = DATA_DIR / "recipes_training_final.json"

DEVICE = "cpu" 

RECIPE_MAX_NEW_TOKENS = 150
RECIPE_MIN_NEW_TOKENS = 50
RECIPE_TEMPERATURE = 0.7
RECIPE_TOP_P = 0.9
RECIPE_TOP_K = 50
RECIPE_REPETITION_PENALTY = 1.2

NAME_MATCHER_DEVICE = "cpu"
NAME_MATCHER_THRESHOLD = 0.6  # Minimum similarity score

os.environ["HF_HUB_DOWNLOAD_TIMEOUT"] = "600"
os.environ["HF_HUB_DISABLE_SYMLINKS_WARNING"] = "1"
os.environ["HF_HUB_DISABLE_PROGRESS_BARS"] = "1"

API_HOST = "0.0.0.0"
API_PORT = 8000
API_RELOAD = False
API_LOG_LEVEL = "info"

CORS_ORIGINS = ["*"]
CORS_CREDENTIALS = True
CORS_METHODS = ["*"]
CORS_HEADERS = ["*"]

LOG_LEVEL = "INFO"
LOG_FORMAT = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
