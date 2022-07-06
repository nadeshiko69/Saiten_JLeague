from email.policy import default
from http.client import HTTPResponse
from django.shortcuts import render, redirect

from .forms import CommentForm
from .models import Post, Team, Player

def frontpage(request):
    teams = Team.objects.all()
    return render(request, "aFirebaseOperator/frontpage.html", {"teams": teams})

def fGetNemberData(request, engName):
    post = Team.objects.get(engName=engName)
    if request.method=="POST" and "run_script" in request.POST:
        import sys
        from function.operateFirebase import operateFirebase
        of = operateFirebase()
        players = of.fReadMemberDataFromFirebase(engName)
        for player in players:
            print(player["name"])
            # DB内にIDが一致する項目がなければ新規登録
            Player.objects.get_or_create(pid=player["id"],
                                         defaults = {
                                             'team':engName,
                                             'pid':player["id"],
                                             'name':player["name"],
                                             'number':player["number"],
                                             'position':player["position"]
                                         }
                                         )

    else:
        CommentForm()

    return render(request, "aFirebaseOperator/team_detail.html")