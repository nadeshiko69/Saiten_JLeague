from firebase_admin import firestore
import firebase_admin
from firebase_admin import credentials
from pyparsing import LRUMemo

class operateFirebase():
    def __init__(self):
        JSON_PATH = 'saitenj-408a1-firebase-adminsdk-r2bv3-1e3090988e.json'
        # Firebase初期化
        self.cred = credentials.Certificate(JSON_PATH)
        firebase_admin.initialize_app(self.cred)
        self.db = firestore.client()
        self.lMemberList = []
      
    # 試合開始前にスタメン / ベンチ情報を登録する   
    def fWriteMemberDataToFirebase(self):
        # コレクションにアクセス
        doc_ref = self.db.collection('news')
        try:
            doc_ref.add({
                'starting': 'a',
                'score'  : '-1'
                })
            
            print("Done")
        except:
            print("Error")
        # TODO：登録メンバーが18人になっていなければWarningを出す
    
    # スタメン/ベンチ情報登録のために、メンバーリストを読み込む　
    def fReadMemberDataFromFirebase(self, teamName):
        self.lMemberList.clear()
        
        doc_ref = self.db.collection('Data2022').document(teamName).collection('Member')
        docs = doc_ref.stream()
        for doc in docs:
            # print(f"id:{doc.id}")
            # print(f"Name:{doc.get('name')}")
            personalData = {
                id:{doc.id},
                name:{doc.get('name')},
                number:{doc.get('number')},
                position:{doc.get('position')}
            }

        
# FOR DEBUG

of = operateFirebase()
of.fWriteMemberDataToFirebase()
of.fReadMemberDataFromFirebase('Nagoya')