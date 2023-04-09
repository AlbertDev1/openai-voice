
import os
import base64
from TTS.api import TTS
from io import BytesIO
import speech_recognition as sr
import logging

logger = logging.getLogger(__name__)

def speech_to_text():
    r = sr.Recognizer()
    with sr.Microphone() as source:
        r.adjust_for_ambient_noise(source)
        logger.info("Say something!")
        audio = r.listen(source, phrase_time_limit=5)

    try:
        text = r.recognize_google(audio)
        logger.info("You said: " + text)
        return text
    except sr.UnknownValueError:
        logger.error("Google Speech Recognition could not understand audio")
        return ""
    except sr.RequestError as e:
        logger.error("Could not request results from Google Speech Recognition service; {0}".format(e))
        return ""
    
def speak_text(text):
    try:
        model_name = os.environ["TTS_MODEL_NAME"] 
        tts = TTS(model_name)
        out = BytesIO()

        ###Example to generate wav files on all the speakers###
        # for i in  range(0, len(tts.speakers)):
        #     tts.tts_to_file(text=text, speaker=tts.speakers[i], file_path="output{0}.wav".format(i))

        tts.tts_to_file(text, speaker=tts.speakers[55], file_path=out)
        out.seek(0)
        audio_data = out.read()
        audio_base64 = base64.b64encode(audio_data).decode("utf-8")
        return audio_base64
    except Exception as e:
        logger.error("An unexpected error occurred while generating speech: {0}".format(e))
        return ""