from re import sub
from firebase_admin import firestore
import firebase_admin
from firebase_admin import credentials
from pyparsing import LRUMemo
import numpy as np
import function.CONFIG

class operateFirebase():
    def __init__(self):
        JSON_PATH = 'function/saitenj-408a1-firebase-adminsdk-r2bv3-1e3090988e.json'
        # Firebase初期化
        self.cred = credentials.Certificate(JSON_PATH)
        firebase_admin.initialize_app(self.cred)
        self.db = firestore.client()
        self.lMemberList = []
        self.lMatchList = []
        self.npPoints = np.empty(0) # ユーザが増えた時に要素数が莫大になるのでNumpyで処理する
        
      
    # 試合開始前にスタメン / ベンチ情報を登録する   
    def fWriteMemberDataToFirebase(self, engName, mid, startingMember, subMember):
        # if len(startingMember) == 11:
        # コレクションにアクセス
        # collectionに追加するときはadd
        # documentに追加するときはset
        base_ref = self.db.collection(function.CONFIG.data20xx).document(engName).collection('Match').document(mid).collection('Member')
        for member in startingMember:
            doc_ref = base_ref.document(member)
            try:
                # TODO : 2回目以降の送信で重複しないようにセーフティ入れる
                doc_ref.set({
                    'starting': 'true',
                    'score'  : -1
                    })
                print("startingMember register done.")
            except:
                print("Error : StartingMember Register")
        for member in subMember:
            doc_ref = base_ref.document(member)
            try:
                doc_ref.set({
                    'starting': 'false',
                    'score'  : -1
                    })
                print("subMember Register done.")
            except:
                print("Error : SubMember Register")
    
    # スタメン/ベンチ情報登録のために、メンバーリストを読み込む　
    def fReadMemberDataFromFirebase(self, teamName):
        self.lMemberList.clear()
        
        doc_ref = self.db.collection(function.CONFIG.data20xx).document(teamName).collection('Member')
        docs = doc_ref.stream()
        for doc in docs:
            personalData = {
                'id':doc.id,
                'name':doc.get('name'),
                'number':doc.get('number'),
                'position':doc.get('position'),
                'point':-1.0
            }
            self.lMemberList.append(personalData)
        
        return self.lMemberList
    
    def fReadMatchDataFromFirebase(self, teamName):
        self.lMatchList.clear()
        
        doc_ref = self.db.collection(function.CONFIG.data20xx).document(teamName).collection('Match')
        docs = doc_ref.stream()        
        for doc in docs:
            matchData = {
                'id':doc.id,
                'home':doc.get('home'),
                'away':doc.get('away'),
                'homescore':doc.get('homescore'),
                'awayscore':doc.get('awayscore'),
                'kickoff':doc.get('kickoff'),
                'section':doc.get('section'),
                'stadium':doc.get('stadium'),
            }
            self.lMatchList.append(matchData)
        
        return self.lMatchList
    
    # 採点結果をfirebaseから読み込む
    def fReadPointsFromFirebase(self, teamName, matchID):
        self.npPoints = np.empty(0)
        doc_ref = self.db.collection(function.CONFIG.data20xx).document('Scores').collection(teamName).where('MatchID', '==', matchID)
        docs = doc_ref.stream()
        for doc in docs:
            appendData = [
                doc.get('MemberID'),
                doc.get('score')
            ]
            self.npPoints = np.append(self.npPoints, appendData)
        return self.npPoints.reshape(int(self.npPoints.size/2),2)
        
    def fWritePointsToFirebase(self, engName, mid, members):
        print("mid = {}".format(mid))
        base_ref = self.db.collection(function.CONFIG.data20xx).document(engName).collection('Match').document(mid).collection('Member')
        for member in members:
            print("Name[{}] / pid[{}] / point[{}] / var[{}] / sdev[{}]".format(member.name, member.pid, member.point, member.var, member.sdev))
            doc_ref = base_ref.document(member.pid)
            if doc_ref.get().exists:
                try:
                    doc_ref.update({
                        'score'  : member.point,
                        'var'    : member.var,
                        'sdev'   : member.sdev,
                        })
                    print(" Score register done.")
                except:
                    print("Score register Failed.")
            else:
                print("No Register.")
# FOR DEBUG

# of = operateFirebase()
# print(of.fReadPointsFromFirebase('Nagoya', 'sMctnFCinggva3GpQye1'))