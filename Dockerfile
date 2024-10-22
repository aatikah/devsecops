# Use an official Python runtime as a parent image
FROM python:3.9-slim

WORKDIR /taskManager

# Copy the requirements.txt file into the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .


# Set environment variables
ENV DJANGO_SETTINGS_MODULE=taskManager.settings
ENV DEBUG=True

# Expose the port that the app runs on
EXPOSE 8000

# Run migrations and collect static files
RUN python manage.py migrate



# Run manage.py
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
