FROM python:3.12-slim

# FFmpeg, Node.js va Docker CLI o'rnatish
# PO Token serverini ishga tushirish uchun docker CLI kerak
RUN apt-get update && apt-get install -y \
    ffmpeg \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mkdir -p downloads temp_audio

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY bot.py .

EXPOSE 8080

# Ishlatish uchun shell skripti: avval PO Token serverini ishga tushirib, keyin botni ishga tushiradi
CMD ["sh", "-c", "docker run --name bgutil-provider -d --init -p 127.0.0.1:4416:4416 brainicism/bgutil-ytdlp-pot-provider && python bot.py"]
