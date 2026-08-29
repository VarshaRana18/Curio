from google import genai
from config import Settings

settings = Settings()

class LLMService:
    def __init__(self):
        self.client = genai.Client(api_key = settings.GEMINI_API_KEY)
        
    def generate_response(self, query:str , search_results : list[dict]):
        context_text = "\n\n".join([
            f"Source {i+1} {res["url"]} : \n {res["content"]}"
            for i,res in enumerate(search_results)
        ])
        
        full_prompt = f"""
        {context_text}
        
        Query : {query}
        
        Please provide a comprehensive, detailed, well-cited accurate response using the above context. Think and reason deeply. Ensure it answers the query the user is asking. Do not use your knowledge until it is absolutely necessary.
        """
        
        response = self.client.models.generate_content_stream(
            model='gemini-3.6-flash',
            contents=full_prompt,
        )
        
        for chunk in response:
            yield chunk.text
        
        
            
            