from typing import List
from sentence_transformers import SentenceTransformer
import numpy as np

class SortSourceService:
    _embedding_model = None
    
    @property
    def embedding_model(self):
        if SortSourceService._embedding_model is None:
            SortSourceService._embedding_model = SentenceTransformer('all-MiniLM-L6-v2')
        return SortSourceService._embedding_model
        
    def sort_sources(self, query : str, search_results : List[dict]):
        relevant_docs = []
        query_embedding = self.embedding_model.encode(query)
        
        for result in search_results:
            res_embedding = self.embedding_model.encode(result.get("content"))
            similarity = np.dot(query_embedding,res_embedding) / (np.linalg.norm(query_embedding) * (np.linalg.norm(res_embedding)))
        
            result["relevance_score"] = float(similarity)
            
            if similarity > 0.5:
                relevant_docs.append(result)
                
        return sorted(relevant_docs,key=lambda res: res["relevance_score"],reverse=True)
    
    
# 1) embedding of Query and Search_results using embedding model: sentence transformers => all-MiniLM-L6-v2
# 2) get the angle between both => cos θ = Σ(Qi.Ri.) / (|Q|.|R|)
            #           Q.R. is dot product
            #           |Q| is magnitude of Q => √ Σ(Qi ²)
            #       and |R| is magnitude of R => √ Σ(Ri ²)
#    value 1 closer to 1 is more similar and near 0 is not similar
# 3) filter based on the similarity score
# 4) return sorted results based on greater similarity