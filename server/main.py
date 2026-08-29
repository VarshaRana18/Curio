from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from pydantic_models.chat_body import ChatBody
from services.search_service import SearchService
from services.sort_source_service import SortSourceService
from services.llm_service import LLMService
import asyncio

app = FastAPI()
search_service = SearchService()
sort_source_service = SortSourceService()
llm_service = LLMService()

@app.websocket('/ws/chat')
async def websocket_chat_endpoint(websocket : WebSocket):
    await websocket.accept()
    
    try:
        data = await websocket.receive_json()
        query = data.get("query")

        if not query:
            await websocket.send_json({"type": "error", "data": "Query is required"})
            return

        search_results = await asyncio.to_thread(search_service.web_search, query)
        sorted_results = await asyncio.to_thread(sort_source_service.sort_sources, query, search_results)
        
        await websocket.send_json({
            "type": "search_result",
            "data": sorted_results 
        })
        
        for chunk in llm_service.generate_response(query, sorted_results):
            await websocket.send_json({
                "type": "content",
                "data": chunk
            })
            await asyncio.sleep(0.01)
            
    except WebSocketDisconnect:
        print("Client disconnected gracefully")
        
    except Exception as e:
        print(f"WebSocket Error: {e}")
        try:
            await websocket.send_json({"type": "error", "data": str(e)})
        except Exception:
            pass
    finally:
        try:
            await websocket.close()
        except Exception:
            pass

# @app.post('/chat')
# def chat_endpoint(body : ChatBody):
#     #search the web and find appropriate sources
#     search_results = search_service.web_search(body.query)
    
#     #sort the sources based on the similarity between the result and query
#     sorted_results = sort_source_service.sort_sources(body.query,search_results)
    
#     #generate response using LLM(here Gemini)
#     response = llm_service.generate_response(body.query,sorted_results)
    
#     return response