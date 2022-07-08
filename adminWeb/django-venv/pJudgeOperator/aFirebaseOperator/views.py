from email.policy import default
from http.client import HTTPResponse
import numbers
from django.shortcuts import render, redirect

from .forms import CommentForm
from .models import Post, Team, Player

def frontpage(request):
    teams = Team.objects.all()
    return render(request, "aFirebaseOperator/frontpage.html", {"teams": teams})

def fGetNemberData(request, engName):
    # 再取得ボタンが押されたらこっち
    if request.method=="POST" and "run_script" in request.POST:
        import sys
        from function.operateFirebase import operateFirebase
        of = operateFirebase()
        players = of.fReadMemberDataFromFirebase(engName)
        for player in players:
            print(player["name"])
            # DB内にIDが一致する項目がなければ新規登録
            nouse, created = Player.objects.get_or_create(pid=player["id"],
                                         defaults = {
                                            'team':engName,
                                            'pid':player["id"],
                                            'name':player["name"],
                                            'number':player["number"],
                                            'position':player["position"]})
            # IDあるから更新しなかったけど背番号が0 ->退団選手
            if (created == False) and player["number"] == 0:
               db = Player.objects.get(pid=player["id"])
               db.number = 0
               db.save()
    # 最初にアクセスされるのはこっち
    else:
        pass

    # DBから選手情報を取得して表示    
    data = Player.objects.all()
    data.filter(number=0).delete() # 退団選手は背番号0としているので非表示
    data = data.order_by('number')
    params = {'players':data}

    return render(request, "aFirebaseOperator/team_detail.html", params)

