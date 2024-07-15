from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse
from .models import Appointment

# unit tests for backend
class AppointmentAPITest(APITestCase):

    def setUp(self):
        self.appointment = Appointment.objects.create(
            patient="John Doe",
            doctor="Dr. Smith",
            date="2024-07-15",
            time="10:00:00"
        )
        self.list_create_url = reverse('appointment-list')
        self.detail_url = reverse('appointment-detail', kwargs={'pk': self.appointment.id})

    def test_get_appointments(self):
        response = self.client.get(self.list_create_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

    def test_post_appointment(self):
        data = {
            "patient": "Jane Doe",
            "doctor": "Dr. Brown",
            "date": "2024-07-16",
            "time": "11:00:00"
        }
        response = self.client.post(self.list_create_url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Appointment.objects.count(), 2)

    def test_get_appointment_by_id(self):
        response = self.client.get(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['patient'], "John Doe")

    def test_delete_appointment(self):
        response = self.client.delete(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(Appointment.objects.count(), 0)
