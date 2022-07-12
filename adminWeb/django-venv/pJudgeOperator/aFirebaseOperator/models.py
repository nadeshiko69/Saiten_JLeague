# DBと接続するための記述
from pyexpat import model
from django.db import models

class Post(models.Model):
    title = models.CharField(max_length=64)
    slug = models.SlugField()
    intro = models.TextField()
    body = models.TextField()
    posted_date = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-posted_date"]


class Comment(models.Model):
    post = models.ForeignKey(Post, related_name="comments", on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    email = models.EmailField()
    body = models.TextField()
    posted_date = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-posted_date"]
        
        
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

# 試合情報
class Match(models.Model):
    mid = models.CharField(max_length=32)
    section = models.IntegerField()
    hometeam = models.CharField(max_length=4)
    homescore = models.IntegerField()
    awayteam = models.CharField(max_length=4)
    awayscore = models.IntegerField()
    kickoff = models.DateField()
    stadium = models.CharField(max_length=32)
    