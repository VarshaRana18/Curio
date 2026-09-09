from google import genai
from google.genai.errors import APIError
import time
from config import Settings

settings = Settings()

class LLMService:
    MODELS = [
        "gemini-2.5-flash",
        "gemini-2.0-flash",
        "gemini-1.5-flash",
    ]
    def __init__(self):
        self.client = genai.Client(api_key = settings.GEMINI_API_KEY)
        
    def generate_response(self, query:str , search_results : list[dict]):
        last_exception = None
        
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
        
        for model_name in self.MODELS:
            try:
                response = self.client.models.generate_content_stream(
                    model='gemini-3.6-flash',
                    contents=full_prompt,
                )
                
                for chunk in response:
                    if chunk.text:
                        yield chunk.text
                return 
                    
            except APIError as e:
                # Catch 503 (Overloaded) or 429 (Rate Limit)
                if e.code in (503, 429):
                    print(f"Model {model_name} overloaded ({e.code}). Switching to next fallback...")
                    time.sleep(0.5)
                    last_exception = e
                    continue
                raise e
            
        yield f"The AI research service is temporarily overloaded. Please try your search again in a moment."
                
        
        
            
            