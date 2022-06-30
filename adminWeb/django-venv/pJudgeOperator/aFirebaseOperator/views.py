from http.client import HTTPResponse
from django.shortcuts import render, redirect

from .forms import CommentForm
from .models import Post

def frontpage(request):
    posts = Post.objects.all()
    return render(request, "aFirebaseOperator/frontpage.html", {"posts": posts})

def post_detail(request, slug):
    post = Post.objects.get(slug=slug)
    if request.method=="POST" and "run_script" in request.POST:
        import sys
        from function.operateFirebase import operateFirebase
        of = operateFirebase()
        print(of.fReadMemberDataFromFirebase('Nagoya'))

    else:
        CommentForm()

    return render(request, "aFirebaseOperator/post_detail.html")