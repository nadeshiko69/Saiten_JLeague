from django.contrib import admin
from django.urls import path

from aFirebaseOperator.views import frontpage, post_detail

urlpatterns = [
    path('admin/', admin.site.urls),
    path("", frontpage),
    path("<slug:slug>/", post_detail, name="post_detail")
]
