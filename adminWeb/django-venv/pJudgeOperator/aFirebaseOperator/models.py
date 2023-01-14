# DBと接続するための記述
from pyexpat import model
from django.db import models
 
# チーム一覧
class Team(models.Model):
    jpnName = models.CharField(max_length=32)
    engName = models.CharField(max_length=16)

# 選手情報
class Player(models.Model):
    team = models.CharField(max_length=16)
    pid = models.CharField(max_length=32)
    name = models.CharField(max_length=16)
    number = models.IntegerField()
    position = models.CharField(max_length=2)
    point = models.FloatField(default=-1)
    sdev = models.FloatField(default=-1)
    var = models.FloatField(default=-1)
    com = models.FloatField(default=-1)

# 試合情報
class Match(models.Model):
    mid = models.CharField(max_length=32)
    team = models.CharField(max_length=8)
    opponent = models.CharField(max_length=8)
    kickoff = models.DateField()

'''
● DBの内容を過去の状態に戻す時
どこまで巻きもどすかを確認
python manage.py showmigrations
DBを過去の状態に戻す
python manage.py migrate aFirebaseOperator 000X_hogohoge
migrationフォルダ内にある、戻した地点以降のファイルを削除

※モデルの構成要素を変更したい！みたいな時はこの要領で一回無かったことにして作り直す

↑昔の自分の記述が謎、普通に追加できた。下記コミットを参照
commitID = a02f320ecb573d48c295500ac94dfd996f53918d
'''