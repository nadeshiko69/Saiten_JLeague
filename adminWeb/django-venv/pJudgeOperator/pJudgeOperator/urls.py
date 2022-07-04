from django.contrib import admin
from django.urls import path

from aFirebaseOperator.views import frontpage, fGetNemberData

urlpatterns = [
    path('admin/', admin.site.urls),
    path("", frontpage),
    path("<engName>/", fGetNemberData, name="team_detail")
]
