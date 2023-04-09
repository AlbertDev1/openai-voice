import openai
from dotenv import load_dotenv
import os

load_dotenv()  # Load environment variables from the .env file

class GPT_API:
    def __init__(self, api_key=None):
        if api_key is None:
            api_key = os.environ["OPENAI_API_KEY"] 

        if api_key is None:
            raise ValueError("OpenAI API key not found in environment variables or provided as argument")

        openai.api_key = api_key
        self.model_engine = "text-davinci-003"

    def generate_text(self, prompt, max_tokens=3500):
        response = openai.Completion.create(
            engine=self.model_engine,
            prompt=prompt,
            max_tokens=max_tokens,
            n=1,
            stop=None,
            temperature=0.5,
        )

        if response.choices and response.choices[0].text:
            return response.choices[0].text.strip()
        else:
            raise ValueError("Could not generate text")

# Example usage:
# api = GPT3API(api_key="your_openai_api_key")
# generated_text = api.generate_text(prompt="Some text prompt")

