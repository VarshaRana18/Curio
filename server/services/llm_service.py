from google import genai
from config import Settings

settings = Settings()

class LLMService:
    def __init__(self):
        self.client = genai.Client(api_key = settings.GEMINI_API_KEY)
        
    def generate_response(self, query:str , search_results : list[dict]):
        context_text = "\n\n".join([
            f"Source [{i+1}] \nTitle: {res.get('title')}\nURL: {res.get('url')}\nContent: {res.get('content')}"
            for i,res in enumerate(search_results)
        ])
        
        full_prompt = f"""
        
        "You are a precise research assistant. Answer the user's question based strictly on the provided context.
        Cite your sources in the text using bracketed numbers like [1], [2], etc., corresponding to the source number.

        Context:
        {context_text}

        Question:
        {query}
        """
        
        response = self.client.models.generate_content_stream(
            model='gemini-3.6-flash',
            contents=full_prompt,
        )
        
        for chunk in response:
            yield chunk.text
        
        
            
            