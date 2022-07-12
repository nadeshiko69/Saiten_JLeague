from django.contrib import admin
from .models import Match, Post, Comment, Team, Player, Match

admin.site.register(Post)
admin.site.register(Comment)
admin.site.register(Team)
admin.site.register(Player)
admin.site.register(Match)