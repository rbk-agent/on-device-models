# On-Device AI Model Index

Small AI models that run offline on phones, Raspberry Pis, laptops, and browsers. No cloud, no API keys, no network calls.

- Site: <https://rbk-agent.github.io/on-device-models/>
- JSON index: <https://rbk-agent.github.io/on-device-models/models.json>
- Long-form reference (kept from the original README): [docs/model-notes.md](docs/model-notes.md)
- Data for the site (edit this, not the HTML): [site/src/_data/models.json](site/src/_data/models.json)

## Nature & Bioacoustics

- [BirdNET](https://github.com/birdnet-team/BirdNET-Analyzer) — 6,000+ bird species from audio, runs on a Raspberry Pi
- [Google Perch](https://github.com/google-research/perch) — ~15,000 bird species worldwide, few-shot embeddings
- [iNaturalist Vision Small](https://github.com/inaturalist/model-files) — offline nature photo ID, the Seek app's model family
- [MegaDetector V6](https://github.com/microsoft/MegaDetector) — detects animals, people, vehicles in camera-trap photos
- [BatDetect2](https://github.com/macaodha/batdetect2) — bat call detection and species ID (Europe)
- [Pl@ntNet-300K](https://github.com/plantnet/PlantNet-300K) — dataset + training code for your own plant classifier

## Speech: STT & TTS

- [Whisper.cpp](https://github.com/ggerganov/whisper.cpp) — STT in 90+ languages, C/C++, real-time on a Pi with small models
- [sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx) — STT, TTS, VAD, diarization, denoising in one toolkit (npm: sherpa-onnx-node)
- [Moonshine](https://github.com/moonshine-ai/moonshine) — STT built for edge devices, 27M-param tiny tier
- [SenseVoice Small](https://github.com/FunAudioLLM/SenseVoice) — STT + emotion + audio events in one pass
- [Vosk](https://github.com/alphacep/vosk-api) — streaming STT, 20+ languages, ~50 MB models (npm: vosk)
- [Kokoro](https://www.npmjs.com/package/kokoro-js) — frontier TTS at 82M params, Node and browser (kokoro-js)
- [Piper](https://github.com/OHF-Voice/piper1-gpl) — fast TTS, one small model per voice, dozens of languages
- [MeloTTS](https://github.com/myshell-ai/MeloTTS) — multilingual TTS, six languages
- [Echogarden](https://www.npmjs.com/package/echogarden) — speech toolset in pure TypeScript: STT, TTS, alignment, translation

## Speech: Understanding & Cleanup

- [Silero VAD](https://github.com/snakers4/silero-vad) — voice activity detection in ~1 MB, the standard gate before STT
- [pyannote.audio](https://github.com/pyannote/pyannote-audio) — speaker diarization, who spoke when
- [DeepFilterNet](https://github.com/Rikorose/DeepFilterNet) — streaming noise suppression, 48 kHz
- [RNNoise](https://github.com/xiph/rnnoise) — the classic tiny noise suppressor, BSD
- [openWakeWord](https://github.com/dscripka/openwakeword) — trainable wake-word detection
- [3D-Speaker](https://github.com/modelscope/3D-Speaker) — speaker verification and identification

## Audio: Source Separation & Stems

- [Demucs](https://github.com/adefossez/demucs) — quality leader for splitting tracks into stems (npm ONNX port exists)
- [Spleeter](https://github.com/deezer/spleeter) — fast, light stem separation from Deezer
- [Open-Unmix](https://github.com/sigsep/open-unmix-pytorch) — research reference for stem separation

## Audio: Music Transcription & Notation

- [Basic Pitch](https://github.com/spotify/basic-pitch) — polyphonic audio to MIDI (npm: @spotify/basic-pitch)
- [MT3](https://github.com/magenta/mt3) — multi-instrument transcription to MIDI, research-grade
- [ChromaPrint](https://github.com/acoustid/chromaprint) — audio fingerprinting, identify recordings offline

## Audio: Music & Sound Tagging

- [YAMNet](https://tfhub.dev/google/yamnet/1) — 521 sound classes incl. instruments, ~4 MB
- [musicnn](https://github.com/jordipons/musicnn) — genre, instrument, mood tags for music
- [Essentia](https://github.com/MTG/essentia) — full audio analysis toolbox: key, chords, BPM, loudness
- [Detoxify](https://github.com/unitaryai/detoxify) — text toxicity classification (bonus text lane)

## Image Editing & Restoration

- [rembg / U²-Net](https://github.com/danielgatis/rembg) — the standard background remover; u2netp is ~5 MB and browser-capable (npm: modern-rembg)
- [BiRefNet](https://github.com/ZhengPeng7/BiRefNet) — current quality leader for background removal, MIT
- [MODNet](https://github.com/ZHKKKe/MODNet) — real-time portrait matting, ~7 MB quantized
- [RMBG-1.4](https://huggingface.co/briaai/RMBG-1.4) — top open-weight quality, transformers.js-friendly (non-commercial weights)
- [MI-GAN](https://github.com/Picsart-AI-Research/MI-GAN) — object removal, ~27 MB ONNX, proven in-browser
- [LaMa](https://github.com/saic-mdal/lama) — inpainting classic, handles large removals, Apache-2.0
- [IOPaint](https://github.com/Sanster/IOPaint) — self-hosted inpainting server: LaMa, MI-GAN, PowerPaint behind one brush UI
- [PowerPaint](https://github.com/open-mmlab/PowerPaint) — text-guided object ADDITION, removal, outpainting in one model
- [GFPGAN](https://github.com/TencentARC/GFPGAN) — face restoration for old/blurry photos (non-commercial weights)

## Text & Vision Extras

- [Tesseract.js](https://www.npmjs.com/package/tesseract.js) — OCR in pure JavaScript, 100+ languages
- [UpscalerJS](https://www.npmjs.com/package/upscaler) — image super-resolution in Node and browser
- [imgly background-removal](https://github.com/imgly/background-removal-js) — background removal, runs locally
- [Transformers.js](https://huggingface.co/docs/transformers.js) — thousands of HF models in JavaScript

## One SDK, Many Models

- [Desert Ant Core](https://github.com/Desert-Ant-Labs/desert-ant-core) — on-device SDK suite: STT, denoise, language ID, PII redaction (per-model npm packages)
- [PyTorch-Wildlife](https://github.com/microsoft/Pytorch-Wildlife) — MegaDetector + species classifiers, one API

## Contributing

Know a model that belongs here? Open an issue or PR. A model qualifies if it (1) does something useful, (2) runs on consumer hardware without a cloud service, and (3) has a working public download. Edit [site/src/_data/models.json](site/src/_data/models.json) — the site builds from it.