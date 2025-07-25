# Start with a Python 3.9-slim-buster base image.
# We explicitly set the platform to linux/amd64 as per Adobe's requirements for compatibility.
FROM python:3.9-slim-buster --platform=linux/amd64

# Set the working directory inside the Docker container to /app.
# This is where all your project files will reside within the container.
WORKDIR /app

# Copy the requirements.txt file into the container.
# Then, install all the Python libraries listed in requirements.txt.
# We use --no-cache-dir to reduce the final Docker image size.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all your project files from your local directory into the /app directory in the container.
# This includes your main script (process_pdfs.py), documentation (approach_explanation.md),
# and the sample data (sample-data_sets folder).
COPY . .

# Specify the command to run when the Docker container starts.
# This will execute your main Python script, process_pdfs.py.
# The '-u' flag ensures unbuffered output, which is helpful for seeing logs in real-time.
CMD ["python", "-u", "process_pdfs.py"]

# Important Note for Docker Execution & File Paths:
# Adobe's evaluation system will mount input PDFs to '/app/input' and expect output JSONs in '/app/output'.
# Our 'process_pdfs.py' script currently uses relative paths (e.g., "sample-data_sets/PDFs/file03.pdf")
# for testing convenience. When Docker is run by the judges, it will likely map their input files
# into '/app/input' and mount an output directory to '/app/output'.
# Your script should ideally be designed to read from '/app/input' and write to '/app/output'
# directly, especially for Round 1B. For Round 1A, the provided Docker setup and mounting
# scheme by Adobe typically handles the file accessibility for your existing script paths.
# The critical thing is that your script successfully executes and produces JSONs.