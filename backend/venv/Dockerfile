# Use an official Python runtime as a parent image
FROM python:3.8-slim-buster

# Set the working directory to /app
WORKDIR /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev

# Install OpenCV
RUN pip install opencv-python-headless

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 8083 available to the world outside this container
EXPOSE 8083

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
