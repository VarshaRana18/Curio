from fastapi import FastAPI
from pydantic_models.chat_body import ChatBody
from services.search_service import SearchService

app = FastAPI()
search_service = SearchService()

@app.post('/chat')
def chat_endpoint(body : ChatBody):
    #search the web and find appropriate sources
    search_results = search_service.web_search(body.query)
    #sort the sources
    
    #generate response using LLM(here Gemini)
    
    return search_results