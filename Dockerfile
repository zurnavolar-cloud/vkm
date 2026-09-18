FROM python:3.12-slim

# FFmpeg, Node.js (>=20), git va curl o'rnatish
RUN apt-get update && apt-get install -y \
    ffmpeg curl git ca-certificates gnupg lsb-release \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# bgutil POT provider'ni klonlash va scriptni tayyorlash (Node.js usuli)
# Versiyani 2.0.0 ga moslang (plugin versiyasiga qarab)
RUN git clone --single-branch --branch 2.0.0 https://github.com/Brainicism/bgutil-ytdlp-pot-provider.git /app/bgutil \
    && cd /app/bgutil/server \
    && npm ci \
    && npx tsc

RUN mkdir -p downloads temp_audio

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY bot.py .

EXPOSE 8080

CMD ["python", "bot.py"]
