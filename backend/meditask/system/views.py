from .models import Appointment
from rest_framework import viewsets
from .serializers import AppointmentSerializer

class AppointmentViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows appointments to be viewed or edited.
    """
    queryset = Appointment.objects.all().order_by('-date')
    serializer_class = AppointmentSerializer     