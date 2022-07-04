from http.client import HTTPResponse
from django.shortcuts import render, redirect

from .forms import CommentForm
from .models import Post, Team

def frontpage(request):
    teams = Team.objects.all()
    return render(request, "aFirebaseOperator/frontpage.html", {"teams": teams})

def fGetNemberData(request, engName):
    post = Team.objects.get(engName=engName)
    if request.method=="POST" and "run_script" in request.POST:
        import sys
        from function.operateFirebase import operateFirebase
        of = operateFirebase()
        print(of.fReadMemberDataFromFirebase(engName))

    else:
        CommentForm()

    return render(request, "aFirebaseOperator/team_detail.html")