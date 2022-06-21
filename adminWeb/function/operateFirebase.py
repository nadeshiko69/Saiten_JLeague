from firebase_admin import firestore
import firebase_admin
from firebase_admin import credentials

class operateFirebase():
    def __init__(self):
        self.word = "Hello world."
        JSON_PATH = 'saitenj-408a1-firebase-adminsdk-r2bv3-1e3090988e.json'
        # Firebase初期化
        self.cred = credentials.Certificate(JSON_PATH)
        firebase_admin.initialize_app(self.cred)
        self.db = firestore.client()
    
    def print_word(self):
        print(self.word)
        
    def writeMemberDataToFirebase(self):
        # コレクションにアクセス
        doc_ref = self.db.collection('news')
        try:
            doc_ref.add({
                'title': 'a',
                'url'  : 'b'
                })
            
            print("Done")
        except:
            print("Error")
        
# FOR DEBUG

of = operateFirebase()
of.print_word()
of.writeMemberDataToFirebase()