FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y gcc build-essential

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "main.py"]