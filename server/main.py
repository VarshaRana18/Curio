from fastapi import FastAPI
from pydantic_models.chat_body import ChatBody
from services.search_service import SearchService
from services.sort_source_service import SortSourceService
from services.llm_service import LLMService

app = FastAPI()
search_service = SearchService()
sort_source_service = SortSourceService()
llm_service = LLMService()

@app.post('/chat')
def chat_endpoint(body : ChatBody):
    #search the web and find appropriate sources
    search_results = search_service.web_search(body.query)
    
    #sort the sources based on the similarity between the result and query
    sorted_results = sort_source_service.sort_sources(body.query,search_results)
    
    #generate response using LLM(here Gemini)
    response = llm_service.generate_response(body.query,sorted_results)
    
    return response