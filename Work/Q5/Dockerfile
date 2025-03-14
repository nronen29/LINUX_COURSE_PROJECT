FROM python:3.8
WORKDIR /LINUX_COURSE_PROJECT/Work
COPY ../Q2/requirements.py .
COPY ../Q2/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python", "requirements.py"]
