from email.policy import default
from http.client import HTTPResponse
from collections import Counter
from statistics import stdev, variance
from django.shortcuts import render

from function.operateFirebase import operateFirebase

from .models import Team, Player, Match
import datetime
import numpy as np
import function.CONFIG


DEBUG_MODE = False # 消しても良さそう、要検証


# FirebaseのInitialize_Appを複数回起動しないようにクラス化
class firebaseOperator:
    of = operateFirebase()

# TopPageの表示
def frontpage(request):
    teams = Team.objects.all()
    return render(request, "aFirebaseOperator/frontpage.html", {"teams": teams})


# メンバー入力画面の表示
def fGetNemberData(request, engName):
    if request.method=="POST":
        # 必要な情報の確保
        # today = datetime.datetime.today() # 入力日
        month = int(request.POST.get("month"))
        day = int(request.POST.get("day"))
        print(month, day)
        today = datetime.datetime(function.CONFIG.year,month,day) #- datetime.timedelta(days=3)
        jpnName = Team.objects.get(engName=engName).jpnName # 入力対象のチーム名
        # 再取得ボタンが押されたらこっち
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
                                                'position':player["position"],
                                                'point':-1.0})
                # IDあるから更新しなかったけど背番号が0 = 退団選手。 DjangoのDBも背番号を更新
                db = Player.objects.get(pid=player["id"])
                db.point = -1.0
                if (created == False) and player["number"] == 0:
                    db.number = 0
                db.save()
            
            
            # 試合情報をDjangoのDBに格納
            matches = firebaseOperator.of.fReadMatchDataFromFirebase(engName)

            for match in matches:
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
            mid = Match.objects.get(team = jpnName, kickoff = today).mid
            startingMember = request.POST.getlist("starting_number")
            subMember = request.POST.getlist("substitute_number")
            print(startingMember)
            print(subMember)
            if len(startingMember) == 11 and len(subMember) <= 7: # スタメン/ ベンチの登録
                if Match.objects.filter(team = jpnName, kickoff = today).exists() or DEBUG_MODE == True:  # 送信を押した日に試合があればidを取得して送付
                    firebaseOperator.of.fWriteMemberDataToFirebase(engName, mid, startingMember, subMember)
                    print("Register done.")
            elif len(startingMember) == 0 and len(subMember) == 0 :  # 計算データの登録
                if Match.objects.filter(team = jpnName, kickoff = today - datetime.timedelta(days=3)).exists() or DEBUG_MODE == True:  # 送信を押した日が試合から3日後なら採点情報を登録
                    players = Player.objects.all()
                    firebaseOperator.of.fWritePointsToFirebase(engName, mid, players)
                print("Register done.")
            else:
                print("Register Func is not exec because checkbox_input is invalid.")
            
            
        # 計算ボタンが押されたらこっち
        elif "calc" in request.POST:
            matches = Match.objects.filter(team = jpnName, kickoff__range=[today - datetime.timedelta(days=3),today]).order_by('kickoff') # 3日前から今日の間に開催された試合の情報を抽出
            points = firebaseOperator.of.fReadPointsFromFirebase(engName,matches[0].mid) # 採点結果を読み込み
            fCalcAveragePoints(engName, points) # みんなの採点結果の平均を計算
            pass
            
            
        # 最初にアクセスされるのはこっち
        else:
            pass

    # DBから選手情報を取得して表示    
    data = Player.objects.all()
    data.filter(number=0).delete() # 退団選手は背番号0としているので非表示
    data = data.order_by('number')
    params = {'players':data}

    return render(request, "aFirebaseOperator/team_detail.html", params)

def fCalcAveragePoints(engName, points):
    players = firebaseOperator.of.fReadMemberDataFromFirebase(engName)
    for player in players:
        points_eachMember = points[np.any(points==player["id"], axis=1)][:,1] # 採点の値のみ抽出
        points_eachMember = [float(s) for s in points_eachMember] # 取得するときにstrで取ってきてるのでfloatに変換。後で修正する
        print(points_eachMember)
        print(player["name"])
        if len(points_eachMember) != 0:
            ave_point = sum(points_eachMember) / len(points_eachMember) # 平均値
            sdev = stdev(points_eachMember) # 標準偏差
            var = variance(points_eachMember) # 分散
            # com = Counter(points_eachMember).most_common(1) # 最頻値 = 2つ以上の値がが同率で最貧だった場合Failになるので一旦なし
            
            db = Player.objects.get(pid=player["id"])
            db.point = ave_point
            db.sdev = sdev
            db.var = var
            # db.com = com
            db.save()

            
def ReloadPoints(self, engName):
    players = firebaseOperator.of.fReadMemberDataFromFirebase(engName)
    for player in players:
        db = Player.objects.get(pid=player["id"])
        db.point = -1
        db.save()