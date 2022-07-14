from email.policy import default
from http.client import HTTPResponse
import math
import numbers
from django.shortcuts import render, redirect

import sys
from function.operateFirebase import operateFirebase

from .models import Team, Player, Match

import datetime

# FirebaseのInitialize_Appを複数回起動しないようにクラス化
class firebaseOperator:
    of = operateFirebase()

# TopPageの表示
def frontpage(request):
    teams = Team.objects.all()
    return render(request, "aFirebaseOperator/frontpage.html", {"teams": teams})


# メンバー入力画面の表示
def fGetNemberData(request, engName):
    # 再取得ボタンが押されたらこっち
    if request.method=="POST":
        if "run_script" in request.POST:
            # 選手情報をDjangoのDBに格納
            players = firebaseOperator.of.fReadMemberDataFromFirebase(engName)
            for player in players:
                # DB内にIDが一致する項目がなければ新規登録
                nouse, created = Player.objects.get_or_create(pid=player["id"],
                                            defaults = {
                                                'team':engName,
                                                'pid':player["id"],
                                                'name':player["name"],
                                                'number':player["number"],
                                                'position':player["position"]})
                # IDあるから更新しなかったけど背番号が0 = 退団選手。 DjangoのDBも背番号を更新
                if (created == False) and player["number"] == 0:
                    db = Player.objects.get(pid=player["id"])
                    db.number = 0
                    db.save()
            
            
            # 試合情報をDjangoのDBに格納
            matches = firebaseOperator.of.fReadMatchDataFromFirebase(engName)
            # 必要な情報の確保
            dt_now = datetime.datetime.today() # 入力日
            jpnName = Team.objects.get(engName=engName).jpnName # 入力対象のチーム名

            for match in matches:
                # matchDay, matchTime = match["kickoff"].isoformat('minutes').split()
                # print(matchDay)
                # matchDay = datetime.datetime(
                #     match["kickoff"].year,
                #     match["kickoff"].month,
                #     match["kickoff"].day
                # )
                opponent = match["home"] if match["home"] != jpnName else match["away"] # 対戦相手を抽出
                nouse, created = Match.objects.get_or_create(mid=match["id"],
                                            defaults = {
                                                'mid':match["id"],
                                                'team':jpnName,
                                                'opponent':opponent,
                                                'kickoff':match["kickoff"]
                                            })   
                
        # 送信ボタンが押されたらこっち
        elif "submit" in request.POST:
            startingMember = request.POST.getlist("starting_number")
            substituteMember = request.POST.getlist("substitute_number")
            
            # submitの日時と一致している試合があればFirebaseに送信
            dt_now = datetime.datetime.today()
            
        # 最初にアクセスされるのはこっち
        else:
            pass

    # DBから選手情報を取得して表示    
    data = Player.objects.all()
    data.filter(number=0).delete() # 退団選手は背番号0としているので非表示
    data = data.order_by('number')
    params = {'players':data}

    return render(request, "aFirebaseOperator/team_detail.html", params)

    