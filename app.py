import logging
from speech import speech_to_text, speak_text
from flask import Flask, render_template
from openai import OpenAI
import asyncio


app = Flask(__name__)
logger = logging.getLogger(__name__)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/", methods=["POST"])
def transcribe():
    try:
        gpt = OpenAI()
        loop = asyncio.new_event_loop()

        async def transcribe_task():
            text = speech_to_text()
            logger.info(text)
            generated_text = gpt.generate_text(text)
            logger.info("gpt3: " + generated_text)
            audio_base64 = speak_text(generated_text)
            return text, generated_text, audio_base64

        transcript, generated_text, audio_base64 = loop.run_until_complete(
            transcribe_task()
        )
        loop.close()

        if transcript:
            return render_template(
                "index.html",
                transcript=transcript,
                generated_text=generated_text,
                audio_base64=audio_base64,
            )
        else:
            return render_template(
                "index.html", error="Unable to convert speech to text."
            )
    except Exception as e:
        logger.error("An unexpected error occurred: {0}".format(e))
        return render_template(
            "index.html", error="An unexpected error occurred. Please try again later."
        )


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    app.run(debug=True, host="0.0.0.0")
