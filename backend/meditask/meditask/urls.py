from django.contrib import admin
from django.urls import include, path
from rest_framework import routers
from system import views

router = routers.DefaultRouter()
router.register(r'appointments', views.AppointmentViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    # path('appointments/', include('system.urls'))
    path('', include(router.urls)),  # Include the router's URL patterns for the notes app
   path('appointments/', include('rest_framework.urls', namespace='rest_framework'))
]      