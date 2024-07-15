from django.db import models
import uuid

class Appointment(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False,unique = True)
    patient = models.CharField(max_length=120)
    doctor = models.CharField(max_length=120)
    date = models.DateField(null=False)
    time = models.CharField(max_length=20, null=False)