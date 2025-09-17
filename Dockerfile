FROM python:3.11-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-jpn \
    libtesseract-dev \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリ
WORKDIR /app

# 依存関係をインストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# プロジェクトコードをコピー
COPY . .

# 静的ファイルを収集
RUN python manage.py collectstatic --noinput

# GunicornでDjangoを起動
CMD ["gunicorn", "b_ocr.wsgi:application", "--bind", "0.0.0.0:8000"]
