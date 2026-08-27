from config import Settings
from tavily import TavilyClient
import trafilatura

settings = Settings()
tavily_client = TavilyClient(api_key=settings.TAVILY_API_KEY)

class SearchService:
    def web_search(self,query:str):
        results = []
        response = tavily_client.search(query,max_results=10)
        search_results = response.get("results",[])
        
        for result in search_results:
            downloaded = trafilatura.fetch_url(result.get("url"))
            content = trafilatura.extract(downloaded)
            
            safe_content = content or result.get("content") or ""
            
            results.append({
                "title" : result.get("title"),
                "url" : result.get("url"),
                "content" : safe_content
            })
            
        return results