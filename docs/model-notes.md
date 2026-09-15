# On-Device AI Model Index

Small AI models that run **offline on phones, Raspberry Pis, laptops, and browsers**. No cloud, no API keys, no network calls. Organized by what they do.

**What belongs here:** a model that (1) does something useful — identifies nature, understands audio/speech, or processes images/text, (2) runs on consumer hardware without a cloud service, and (3) has a working public download and license.

**Node.js users:** every entry lists its Node SDK status. The ones with a native npm package are marked **node-native**; the rest list what it takes to use them from Node.

## Contents

- [Nature & Bioacoustics](#nature--bioacoustics) — plants, birds, animals, bats
- [Speech: STT & TTS](#speech-stt--tts) — transcribe, synthesize, wake words
- [Speech: Understanding & Cleanup](#speech-understanding--cleanup) — diarization, VAD, denoise, language ID
- [Audio: Source Separation & Stems](#audio-source-separation--stems) — demix tracks into stems
- [Audio: Music Transcription & Notation](#audio-music-transcription--notation) — audio → MIDI/notation
- [Audio: Music & Sound Tagging](#audio-music--sound-tagging) — genre, instruments, general sounds
- [Text & Vision Extras](#text--vision-extras) — OCR, image upscaling, background removal, toxicity
- [One SDK, Many Models](#one-sdk-many-models) — sherpa-onnx, Desert Ant Core, Transformers.js
- [Apps you can try today](#apps-you-can-try-today)

---

## Nature & Bioacoustics

| # | Model | Identifies | Input | Size | License | Node SDK |
|---|-------|-----------|-------|------|---------|-----------|
| 1 | [BirdNET V2.4](#birdnet-v24) | 6,000+ bird species | Audio | ~50 MB | CC BY-NC-SA 4.0 (weights) | Python/C++; no npm |
| 2 | [Google Perch](#google-perch) | ~15,000 bird species | Audio | Laptop-class | Apache-2.0 | TF.js possible |
| 3 | [iNaturalist Vision Small](#inaturalist-vision-small) | Plants, animals, fungi (~500 taxa) | Photo | ~22 MB | MIT | TFLite via Node possible |
| 4 | [MegaDetector V6](#megadetector-v6) | Animals, people, vehicles | Photo | 2.3M params (compact) | MIT (some variants) | Python; ONNX export |
| 5 | [YAMNet](#yamnet) | 521 sounds incl. instruments | Audio | ~4 MB | Apache-2.0 | **node-native** (TF.js ports) |
| 6 | [BatDetect2](#batdetect2) | Bat calls (Europe) | Audio | ~50 MB class | Custom research | Python only |
| 7 | [Pl@ntNet-300K](#plntnet-300k) | Train your own plant classifier | Dataset | — | CC-BY-4.0 | Train in Python, export ONNX |

### BirdNET V2.4

**Identifies 6,000+ bird species from audio**, worldwide. The standard for on-device bird sound ID — runs comfortably on a Raspberry Pi, even a Pi Zero 2 W. Sliding 3-second spectrogram windows in, ranked species list out.

- **Numbers:** 6,522 classes, 50.5 MB FP32, 0.826 GFLOPs per inference. Older V2.2 is 21.3 MB if you need smaller.
- **Runtime:** TensorFlow Lite, CPU-only is fine.
- **License:** ⚠️ split — code is MIT, **model weights are CC BY-NC-SA 4.0** (non-commercial; education and research count as non-commercial).
- **Get it:** [birdnet-team/BirdNET-Analyzer](https://github.com/birdnet-team/BirdNET-Analyzer) · [model downloads](https://birdnet-team.github.io/BirdNET-Analyzer/models.html) · ready-made deployments: [BirdNET-Pi](https://github.com/Nachtzuster/BirdNET-Pi), [BirdNET-Go](https://github.com/tphakala/birdnet-go)
- **Node:** no official SDK. Wrapping the TFLite model with `@tensorflow/tfjs-node` or ONNX Runtime (`onnxruntime-node`) is the practical route.

### Google Perch

Google's bird vocalization model: **~15,000 species, global**, higher accuracy than BirdNET, and outputs 1280-d embeddings you can match against a few labeled clips (few-shot custom classifiers).

- **Runtime:** TensorFlow/JAX; community [TFLite/ONNX ports](https://huggingface.co/justinchuby/Perch-onnx) exist.
- **License:** Apache-2.0 including weights — more permissive than BirdNET's.
- **Get it:** [google-research/perch](https://github.com/google-research/perch) · [Hugging Face](https://huggingface.co/cgeorgiaw/Perch) · [Kaggle](https://www.kaggle.com/models/google/bird-vocalization-classifier)
- **Node:** laptop-class, not phone-first; use the ONNX port with `onnxruntime-node`.

### iNaturalist Vision Small

iNaturalist's published on-device classifier — **plants, animals, fungi from photos**, fully offline. Same model family that powers the [Seek app](https://www.inaturalist.org/pages/seek_app).

- **Numbers:** ~22 MB int8-quantized TFLite (CoreML also), ~500 taxa, plus a 0.7 MB geolocation model that down-ranks species unlikely at your GPS point. Taxonomy files included.
- **Caveat:** iNat's full production model (72,000+ taxa) is **private** — these "Small" models are the openly downloadable tier.
- **License:** MIT.
- **Get it:** [inaturalist/model-files](https://github.com/inaturalist/model-files) (releases)
- **Node:** run the TFLite via `@tensorflow/tfjs-node`'s tflite support, or convert to ONNX.

### MegaDetector V6

Microsoft AI for Good's camera-trap model: **detects animals, people, vehicles** with bounding boxes — not species names. Great front-end stage: detect → crop → hand to a species classifier.

- **Numbers:** compact `MDV6-yolov10-c` is 2.3M params (~2% of V5's size), CPU-friendly; larger YOLOv9/v10/RT-DETR variants in the Model Zoo.
- **License:** ⚠️ varies by variant — `MDV6-mit-yolov9-c` is the MIT one; others Apache-2.0 or AGPL-3.0. Check the Model Zoo before shipping.
- **Get it:** [microsoft/MegaDetector](https://github.com/microsoft/MegaDetector) · [Model Zoo](https://microsoft.github.io/MegaDetector/model_zoo/) · framework: [PyTorch-Wildlife](https://github.com/microsoft/Pytorch-Wildlife)
- **Node:** Python API today; ONNX exports make `onnxruntime-node` viable.

### YAMNet

Google's tiny general-purpose sound classifier: **521 AudioSet classes** — instruments (guitar, piano, drums…), machinery, animals, speech, weather. The standard transfer-learning base for custom audio classifiers (retrain the last layer on a few hundred clips).

- **Numbers:** MobileNetV1 backbone, 0.92M params, ~4 MB TFLite. 16 kHz mono in, frame-level scores out. Real-time on phones.
- **License:** Apache-2.0.
- **Get it:** [TF Hub](https://tfhub.dev/google/yamnet/1) · [TFLite fork](https://github.com/antonyharfield/tflite-models-audioset-yamnet) · [Kaggle](https://www.kaggle.com/models/google/yamnet)
- **Node:** **node-native** — multiple TF.js/TFLite ports run in Node and browser.

### BatDetect2

**Bat echolocation call detection + species classification** (European species, ~20 MB models). From the BatDetect2 research team. Audio in, annotated call spans + species out.

- **License:** custom research license (free for non-commercial research; check the repo).
- **Get it:** [macaodha/batdetect2](https://github.com/macaodha/batdetect2)
- **Node:** Python only; ONNX conversion needed for Node use.

### Pl@ntNet-300K

Not a model — **research-grade plant photo dataset + training code** (NeurIPS 2021): ~300K images, ~1,000 species, deliberately long-tailed and label-ambiguous so trained models resemble real-world conditions.

- **License:** code BSD-2-Clause, dataset CC-BY-4.0.
- **Get it:** [plantnet/PlantNet-300K](https://github.com/plantnet/PlantNet-300K) · [dataset on Zenodo](https://zenodo.org/records/4726653)
- **Node:** train in Python (PyTorch), export ONNX, serve with `onnxruntime-node`.

---

## Speech: STT & TTS

| # | Model | Does | Input→Output | Size | License | Node SDK |
|---|-------|------|--------------|------|---------|-----------|
| 8 | [Whisper.cpp](#whispercpp) | STT, 90+ languages | Audio→Text | 39M–1.5B params | MIT | **node-native** (multiple) |
| 9 | [sherpa-onnx](#sherpa-onnx) | STT + TTS + more | Audio↔Text | varies | Apache-2.0 | **node-native** |
| 10 | [Moonshine](#moonshine) | STT for edge devices | Audio→Text | 27M–61M params | MIT | via sherpa-onnx |
| 11 | [SenseVoice Small](#sensevoice-small) | STT + emotion + events | Audio→Text+ | ~230 MB int8 | FunASR v1.1 (weights) | via sherpa-onnx |
| 12 | [Vosk](#vosk) | Streaming STT, 20+ langs | Audio→Text | 50 MB models | Apache-2.0 | **node-native** |
| 13 | [Kokoro](#kokoro) | TTS, high quality | Text→Audio | 82M params | Apache-2.0 | **node-native** (kokoro-js) |
| 14 | [Piper](#piper) | TTS, many voices/languages | Text→Audio | ~60 MB per voice | MIT/GPL (see below) | via sherpa-onnx |
| 15 | [MeloTTS](#melotts) | Multilingual TTS | Text→Audio | ~200 MB class | MIT | Python; ONNX exists |
| 16 | [Echogarden](#echogarden) | Speech toolset: STT, TTS, align, translate | Audio↔Text | varies | MIT (+ GPL parts) | **node-native** |

### Whisper.cpp

C/C++ port of OpenAI's Whisper: **STT in 90+ languages**, with word timestamps. The tiny/base/small models (39M–244M params) run real-time on phones and Pis; quantized ggml files shrink further. `whisper.cpp` prebuilt npm wrappers exist (`nodejs-whisper`, `smart-whisper`).

- **License:** MIT (code); models MIT (OpenAI released them openly).
- **Get it:** [ggerganov/whisper.cpp](https://github.com/ggerganov/whisper.cpp) · models from [HF whisper repos](https://huggingface.co/collections/ggerganov)
- **Node:** **node-native** — `nodejs-whisper` (MIT) wraps it; or shell out to the CLI binary.

### sherpa-onnx

The **swiss-army knife of offline speech**. Next-gen Kaldi + ONNX Runtime: streaming + offline STT (Whisper, Moonshine, SenseVoice, Zipformer, Paraformer…), TTS (VITS, Kokoro, Matcha), speaker ID, diarization, VAD, keyword spotting, audio tagging, speech denoising (GTCRN, DPDFNet), spoken language ID, and source separation. Runs on x86/ARM/Pi/NPU targets.

- **License:** Apache-2.0 (code; model licenses vary — most are Apache/MIT).
- **Get it:** [k2-fsa/sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx) · [npm: sherpa-onnx-node](https://www.npmjs.com/package/sherpa-onnx-node) · [model zoo releases](https://github.com/k2-fsa/sherpa-onnx/releases) (prebuilt ONNX models)
- **Node:** **node-native** — official addon covers every task: `npm i sherpa-onnx-node`.

### Moonshine

STT **designed for edge hardware** (Useful Sensors). Variable-length windows instead of Whisper's fixed 30s chunks, so short utterances transcribe several times faster. Tiny = 27M params (microcontroller- and browser-class), Base = 61M.

- **License:** MIT (models and code; new streaming multilingual models under Moonshine Community License — check per-model).
- **Get it:** [moonshine-ai/moonshine](https://github.com/moonshine-ai/moonshine) · [HF: UsefulSensors/moonshine](https://huggingface.co/UsefulSensors/moonshine)
- **Node:** via `sherpa-onnx-node` (Moonshine is one of its ASR backends).

### SenseVoice Small

Alibaba's **multi-task STT**: transcription + **emotion recognition + audio event detection** (laughter, music, applause) in one pass. Mandarin, Cantonese, English, Japanese, Korean. Very fast for its capability; ~230 MB as int8 ONNX.

- **License:** code MIT; weights under the **FunASR Model License v1.1** — commercial use permitted with attribution.
- **Get it:** [FunAudioLLM/SenseVoice](https://github.com/FunAudioLLM/SenseVoice)
- **Node:** via `sherpa-onnx-node` (SenseVoice is a supported backend).

### Vosk

**Streaming offline STT**, 20+ languages, ~50 MB models, runs on Raspberry Pi and Android. Long-established, stable, with bindings for many languages **including Node** (`vosk` npm package).

- **License:** Apache-2.0.
- **Get it:** [alphacep/vosk-api](https://github.com/alphacep/vosk-api) · [npm: vosk](https://www.npmjs.com/package/vosk) · [models](https://alphacephei.com/vosk/models)
- **Node:** **node-native** — official `vosk` npm binding.

### Kokoro

**Frontier TTS at 82M params** — best quality-per-size available, won an OpenAI TTS arena against much larger models. Quantized ONNX build is ~92 MB. The `kokoro-js` package runs it in browser (WASM) and Node.

- **License:** Apache-2.0 (weights included).
- **Get it:** [npm: kokoro-js](https://www.npmjs.com/package/kokoro-js) · [HF: onnx-community/Kokoro-82M-ONNX](https://huggingface.co/onnx-community/Kokoro-82M-ONNX) · original: [hexgrad/Kokoro-82M](https://huggingface.co/hexgrad/Kokoro-82M)
- **Node:** **node-native** — `npm i kokoro-js`.

### Piper

**Fast local TTS** — one small ONNX model per voice (~60 MB), dozens of languages/voices, real-time on a Raspberry Pi 4. Powers Home Assistant's voice pipeline and NVDA. ⚠️ Licensing changed: original [rhasspy/piper](https://github.com/rhasspy/piper) is MIT but archived (Oct 2025); active development is [OHF-Voice/piper1-gpl](https://github.com/OHF-Voice/piper1-gpl) under GPL-3.0. Each **voice** carries its own terms — check the voice's MODEL_CARD before commercial use.

- **Node:** no official npm; use via `sherpa-onnx-node` (VITS/Piper models supported) or spawn the binary.

### MeloTTS

High-quality **multilingual TTS** (English, Spanish, French, Chinese, Japanese, Korean) by MyShell, ~CPU-realtime capable. Bigger than Kokoro but strong multilingual coverage.

- **License:** MIT.
- **Get it:** [myshell-ai/MeloTTS](https://github.com/myshell-ai/MeloTTS)
- **Node:** Python-first; ONNX exports exist for `onnxruntime-node` use.

### Echogarden

A **speech toolset in pure TypeScript**: STT (whisper.cpp-backed), TTS, forced alignment, speech translation, language detection, and source separation — with a friendly API and MIT license (whisper models MIT; some components GPL).

- **License:** MIT + GPL-3.0 (mixed — check which components you use).
- **Get it:** [npm: echogarden](https://www.npmjs.com/package/echogarden) · [echogarden-project/echogarden](https://github.com/echogarden-project/echogarden)
- **Node:** **node-native** — `npm i echogarden`.

---

## Speech: Understanding & Cleanup

| # | Model | Does | Input | License | Node SDK |
|---|-------|------|-------|---------|-----------|
| 17 | [Silero VAD](#silero-vad) | Voice activity detection | Audio | MIT | **node-native** |
| 18 | [pyannote](#pyannote) | Speaker diarization: who spoke when | Audio | MIT (code) | Python; ONNX exports |
| 19 | [DeepFilterNet](#deepfilternet) | Noise suppression, streaming | Audio | Apache-2.0? (see below) | via sherpa-onnx |
| 20 | [RNNoise](#rnnoise) | Classic noise suppression, tiny | Audio | BSD-3 | C lib; wasm exists |
| 21 | [openWakeWord](#openwakeword) | Wake word detection, trainable | Audio | Apache-2.0 | Python; ONNX portable |
| 22 | [3D-Speaker](#3d-speaker) | Speaker verification/ID | Audio | Apache-2.0 | Python; ONNX |

### Silero VAD

**Voice activity detection** in ~1 MB (ONNX) — the standard "is someone speaking" gate before STT. Used by everyone. 30ms chunks, 16k/8k sample rates, extremely fast on CPU.

- **License:** MIT.
- **Get it:** [snakers4/silero-vad](https://github.com/snakers4/silero-vad)
- **Node:** **node-native** — `@ricky0123/vad-node` (official-recommended wrapper), or raw ONNX via `onnxruntime-node`.

### pyannote

**Speaker diarization** — who spoke when — plus overlap detection and speaker embeddings. The research standard. Note: pyannote's segmentation models are gated on HF (accept terms); code is MIT.

- **License:** MIT (code); model terms on each HF model card.
- **Get it:** [pyannote/pyannote-audio](https://github.com/pyannote/pyannote-audio) · [HF models](https://huggingface.co/pyannote)
- **Node:** Python-first; ONNX community exports exist for `onnxruntime-node`.

### DeepFilterNet

**Streaming noise suppression** (DeepFilterNet3) — real-time speech denoising with a tiny footprint, 48 kHz. Framework-agnostic ONNX available via sherpa-onnx.

- **License:** ⚠️ source-available with restrictions — free for most uses, commercial terms apply at scale. Verify the repo before shipping.
- **Get it:** [Rikorose/DeepFilterNet](https://github.com/Rikorose/DeepFilterNet)
- **Node:** run the ONNX through `sherpa-onnx-node`'s denoiser (GTCRN/DPDFNet models, similar quality class).

### RNNoise

The **classic** recurrent-network noise suppressor — tiny (~1 MB), BSD-licensed, runs anywhere including embedded. Older than the deep-filter approaches but battle-tested (Firefox used it for years in WebRTC).

- **License:** BSD-3-Clause.
- **Get it:** [xiph/rnnoise](https://github.com/xiph/rnnoise)
- **Node:** C library; community WASM builds exist for browser/Node.

### openWakeWord

**Trainable wake-word detection** ("Hey Jarvis", "Alexa"-style) on-device, with pre-trained models and a training pipeline for custom phrases. ~250 KB–2 MB models.

- **License:** Apache-2.0.
- **Get it:** [dscripka/openWakeWord](https://github.com/dscripka/openwakeword)
- **Node:** Python-first; the ONNX models port to `onnxruntime-node` (community examples exist).

### 3D-Speaker

ModelScope's **speaker verification / identification** toolkit: embeddings + verification, cross-modal (audio-video) options, Apache-2.0.

- **Get it:** [modelscope/3D-Speaker](https://github.com/modelscope/3D-Speaker)
- **Node:** Python-first; ONNX exports for `onnxruntime-node`.

---

## Audio: Source Separation & Stems

Split a mixed track into isolated stems (vocals, drums, bass, other) — the "audio stemming" lane.

| # | Model | Stems | License | Node SDK |
|---|-------|-------|---------|-----------|
| 23 | [Demucs](#demucs) | 2/4/6 stems, SOTA quality | MIT | **node-native** (npm port) |
| 24 | [Spleeter](#spleeter) | 2/4/5 stems, fast | MIT | Python; TF SavedModel |
| 25 | [Open-Unmix](#open-unmix) | Research stem separation | BSD-3? (see below) | Python |
| 26 | [sherpa-onnx separation](#sherpa-onnx-separation) | Speech separation (2 speakers) | Apache-2.0 | **node-native** |

### Demucs

Meta's **hy-transformer stem separator** — the quality leader for music demixing (vocals/drums/bass/other, or 6-stem split). htdemucs is the default; V3 GPU-class but CPU-viable for offline use.

- **License:** MIT (code + weights).
- **Get it:** [adefossez/demucs](https://github.com/adefossez/demucs) (research code) · [facebookresearch/demucs](https://github.com/facebookresearch/demucs)
- **Node:** **node-native** — the `demucs` npm package is a JS/ONNX port ("This is a port of Meta's MIT-licensed Demucs… to JavaScript+ONNX").

### Spleeter

Deezer's stem separator — 2/4/5-stem models, fast on CPU, MIT. Older than Demucs and lower quality, but very light and long-proven. TensorFlow SavedModel format.

- **Get it:** [deezer/spleeter](https://github.com/deezer/spleeter)
- **Node:** Python/TF-first; SavedModel → ONNX conversion is straightforward, or shell out to the CLI.

### Open-Unmix

SIGSEP's research reference for stem separation (UMX). Basis of much academic work. ⚠️ license per-repo — check before shipping.

- **Get it:** [sigsep/open-unmix](https://github.com/sigsep/open-unmix)
- **Node:** Python; ONNX export possible.

### sherpa-onnx separation

Two-speaker speech separation models (not music stems) shipped with sherpa-onnx — useful for untangling interview/meeting audio.

- **Node:** same `sherpa-onnx-node` package as everything else sherpa.

---

## Audio: Music Transcription & Notation

Audio → MIDI / notation. This lane is thinner than the others — the open models that exist are strong but the field is research-grade.

| # | Model | Outputs | License | Node SDK |
|---|-------|---------|---------|-----------|
| 27 | [Basic Pitch](#basic-pitch) | Polyphonic audio → MIDI | Apache-2.0 | **node-native** |
| 28 | [MT3](#mt3) | Multi-instrument → MIDI, all at once | Apache-2.0 | Python/JAX |
| 29 | [musicnn](#musicnn) | Music tags (genre, instruments, mood) | ISC | Python; portable |
| 30 | [ChromaPrint](#chromaprint) | Audio fingerprinting (not transcription) | LGPL-2.1+ | **C lib, wasm** |

### Basic Pitch

Spotify's **polyphonic audio → MIDI** converter: pitch bend, note onsets, tempo-agnostic, works on any instrument (voice, guitar, piano, birdsong even). CoreML/TF Lite/ONNX exports ship with it — genuinely runs on-device.

- **License:** Apache-2.0.
- **Get it:** [spotify/basic-pitch](https://github.com/spotify/basic-pitch) · **npm: `@spotify/basic-pitch`** (official JS package)
- **Node:** **node-native** — `npm i @spotify/basic-pitch` — audio in, MIDI out, in pure JS/TF.js.

### MT3

Google's **multi-task multitrack transcription**: transcribes multiple instruments simultaneously into MIDI with a single T5-style model — piano, drums, guitar, full ensembles. Research-grade (JAX), heavier than Basic Pitch, but the only open model doing multi-instrument notation end-to-end.

- **License:** Apache-2.0 (code; dataset/checkpoint terms vary).
- **Get it:** [magenta/mt3](https://github.com/magenta/mt3)
- **Node:** Python/JAX-first; no JS port; export to ONNX would be a project.

### musicnn

Pre-trained **music audio taggers**: genre, instruments, mood, tempo (MagnaTagATune + Million Song training). Small CNNs, CPU-fast, `pip install musicnn`.

- **License:** ISC.
- **Get it:** [jordipons/musicnn](https://github.com/jordipons/musicnn)
- **Node:** Python-first; small CNNs port to ONNX easily.

### ChromaPrint

Not transcription — **audio fingerprinting** (the AcoustID backend): identify *what recording is this* by matching a compact fingerprint against a database. "Shazam-like" ID for your own music library, fully offline (matching side).

- **License:** LGPL-2.1+.
- **Get it:** [acoustid/chromaprint](https://github.com/acoustid/chromaprint)
- **Node:** C library; WASM builds exist; or shell out to `fpcalc`.

---

## Audio: Music & Sound Tagging

| # | Model | Does | License | Node SDK |
|---|-------|------|---------|-----------|
| 31 | [YAMNet](#yamnet-1) | 521 general sounds incl. instruments | Apache-2.0 | **node-native** |
| 32 | [musicnn](#musicnn-1) | Music genre/instrument/mood tags | ISC | Python |
| 33 | [Essentia](#essentia) | Full audio-analysis toolbox | AGPL-3.0 | **node-native** (essentia.js) |
| 34 | [Detoxify](#detoxify) | Text toxicity (bonus text lane) | Apache-2.0 | Python |

*(YAMNet and musicnn appear in the nature section too — repeated here because they're the sound-tagging lane.)*

### YAMNet

**521 AudioSet sound classes** — the catch-all "what am I hearing?" model, ~4 MB, real-time, Apache-2.0. Standard base for custom sound classifiers via last-layer retraining.

- **Get it:** [TF Hub](https://tfhub.dev/google/yamnet/1) · [TFLite fork](https://github.com/antonyharfield/tflite-models-audioset-yamnet)
- **Node:** **node-native** — TF.js ports run in Node/browser.

### musicnn

Music tags out of the box (`guitar`, `techno`, `ambient`, `fast`…). See [entry above](#musicnn).

### Essentia

MTG's **C++ audio/music analysis toolbox** — huge algorithm library: tonal (key, chords, pitch), rhythm (BPM), loudness (EBU R128), spectral descriptors, plus ML model inference. This is the "everything else in audio analysis" entry.

- **License:** ⚠️ AGPL-3.0 (matters for commercial: dynamic-linking workarounds discussed in their docs; essentia.js is AGPL too).
- **Get it:** [MTG/essentia](https://github.com/MTG/essentia) · **npm: essentia.js** (WASM)
- **Node:** **node-native** — `essentia.js` ships WASM builds.

### Detoxify

Bonus text lane: **toxicity classification** for comments/moderation (3 Jigsaw challenges). Small BERT-class models.

- **License:** Apache-2.0.
- **Get it:** [unitaryai/detoxify](https://github.com/unitaryai/detoxify)
- **Node:** Python-first; HF transformers.js can load the same weights.

---

## Image Editing & Restoration

| # | Model | Does | License | Node SDK |
|---|-------|------|---------|-----------|
| 39 | [rembg / U²-Net](#rembg-u2net) | Background removal | MIT | **node-native** (modern-rembg) |
| 40 | [BiRefNet](#birefnet) | Highest-quality background removal | MIT | ONNX |
| 41 | [MODNet](https://github.com/ZHKKKe/MODNet) | Portrait matting, real time | Apache-2.0 | **node-native** (transformers.js) |
| 42 | [RMBG-1.4](#rmbg-14) | Background removal, top quality | Non-commercial weights | **node-native** (transformers.js) |
| 43 | [MI-GAN](#mi-gan) | Object removal, ~27 MB | MIT | ONNX |
| 44 | [LaMa](#lama) | Inpainting, large masks | Apache-2.0 | ONNX |
| 45 | [IOPaint](#iopaint) | Inpainting server, all models one UI | Apache-2.0 | CLI |
| 46 | [PowerPaint](#powerpaint) | Object ADDITION, removal, outpainting | MIT/Apache-2.0 | CLI (IOPaint) |
| 47 | [GFPGAN](#gfpgan) | Face restoration | Non-commercial (S-Lab) | CLI |

### rembg / U²-Net

**The standard open background remover.** u2netp is a ~5 MB ONNX that runs in the browser; full u2net (~170 MB) is higher quality. MIT covers tool and weights. `npm i modern-rembg` runs it in Node/browser.

### BiRefNet

**The current quality leader for background removal** — bilateral reference for high-res dichotomous segmentation, MIT including weights. When u2net edges aren't good enough. ONNX exports for onnxruntime-node.

### RMBG-1.4

**BRIA's IS-Net-based remover — arguably the best open-weight quality**, with first-class transformers.js support (easy browser demos, ~44 MB). ⚠️ weights are source-available **non-commercial**; commercial use requires BRIA's paid license. Trained on fully licensed data, which is why it's restricted.

### MI-GAN

**Object removal via inpainting, mobile-class** (Picsart, ICCV 2023). Brush over anything and it disappears: ~27 MB ONNX, fast enough for interactive use, proven in-browser for watermark removal (onnxruntime-web/WebGPU).

### LaMa

**The classic resolution-robust inpainting model** (WACV 2022, Samsung, Apache-2.0). Better than MI-GAN on large missing areas and complex textures; bigger and slower. Community ONNX exports (sapienkit/LaMa-ONNX) for onnxruntime-node.

### IOPaint

**Self-hosted inpainting server** (Apache-2.0): local web app with brush-masking UI serving LaMa, MI-GAN, PowerPaint, and more. CPU works; GPU recommended for diffusion models. The easiest way to try all these models today.

### PowerPaint

**The realistic answer to "add something to a photo"** (ECCV 2024, MIT code + Apache-2.0 weights): brush a region, describe it in text, and it inpaints the object in with proper lighting and blend — plus removal and outpainting from the same model. SD-based, so laptop/GPU-class — the honest size floor for believable object insertion today.

### GFPGAN

**Face restoration for old/blurry/compressed photos** (Tencent ARC, ~300 MB class). The "restore my grandparents' photo" model. ⚠️ S-Lab license: non-commercial research terms — CodeFormer has the same restriction.

---

## Text & Vision Extras

The "didn't know this existed" lane — image and text tasks that have good on-device options with Node support.

| # | Model | Does | License | Node SDK |
|---|-------|------|---------|-----------|
| 35 | [Tesseract.js](#tesseractjs) | OCR, 100+ languages | Apache-2.0 | **node-native** |
| 36 | [UpscalerJS](#upscalerjs) | Image super-resolution | MIT | **node-native** |
| 37 | [imgly background-removal](#imgly-background-removal) | Background removal | custom permissive-ish | **node-native** |
| 38 | [Transformers.js](#transformersjs) | 1000s of HF models in JS | Apache-2.0 | **node-native** |

### Tesseract.js

**OCR in pure JavaScript** — WASM port of Tesseract, 100+ languages, runs in browser and Node. The classic "extract text from images" on-device option.

- **License:** Apache-2.0.
- **Get it:** [npm: tesseract.js](https://www.npmjs.com/package/tesseract.js) · [tesseract.js docs](https://tesseract.projectnaptha.com/)

### UpscalerJS

**Image upscaling/super-resolution** in JS — browser and Node compatible, MIT, multiple model sizes from fast to quality. `npm i upscaler`.

- **Get it:** [npm: upscaler](https://www.npmjs.com/package/upscaler) · [thekevinscott/UpscalerJS](https://github.com/thekevinscott/UpscalerJS)

### imgly background-removal

**Background removal** (people/products) in browser JS by IMG.LY — segmentation model runs locally, no server. ⚠️ custom license — free for most uses, commercial terms at scale (check [LICENSE.md](https://github.com/imgly/background-removal-js)).

- **Get it:** [npm: @imgly/background-removal](https://www.npmjs.com/package/@imgly/background-removal) · [imgly/background-removal-js](https://github.com/imgly/background-removal-js)

### Transformers.js

Not one model — **the whole Hugging Face ecosystem in JavaScript**. Run 1000s of ONNX-converted models (NLP, vision, audio, multimodal) natively in Node and browser, Apache-2.0. If a model you want exists on HF as ONNX, this is your Node SDK for it.

- **Get it:** [npm: @huggingface/transformers](https://www.npmjs.com/package/@huggingface/transformers) · [docs](https://huggingface.co/docs/transformers.js)

---

## One SDK, Many Models

These aren't single models — they're on-device **platforms** where one install gives you many capabilities:

- **[sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx)** (Apache-2.0) — STT, TTS, VAD, diarization, speaker ID, keyword spotting, denoising, separation in one Node package (`sherpa-onnx-node`). The single highest-leverage install for speech work in Node.
- **[Desert Ant Core](https://github.com/Desert-Ant-Labs/desert-ant-core)** (source-available, free for most apps) — polished on-device SDKs: speech recognition (Voz), speech enhancement (Clear), spoken language ID (Ear), PII redaction (Redact), emoji suggestion (Emo), topic tagging (Gist), filler-word detection (Uhm), and more — with Swift/Kotlin/**Node and browser WASM** support from one codebase. Models on HF at [desert-ant-labs](https://huggingface.co/desert-ant-labs). Install per-model: `npm i @desert-ant-labs/<model>`.
- **[Transformers.js](https://huggingface.co/docs/transformers.js)** (Apache-2.0) — everything ONNX-convertible on HF, in Node and browser.
- **[PyTorch-Wildlife](https://github.com/microsoft/Pytorch-Wildlife)** (MIT) — MegaDetector + regional species classifiers with one consistent Python API.

---

## Apps you can try today

| App | What it does | Offline? |
|-----|-------------|----------|
| [Merlin Bird ID](https://merlin.allaboutbirds.org/) (Cornell) | Bird photo ID + live sound ID | Photo ID yes, Sound ID partially |
| [Seek by iNaturalist](https://www.inaturalist.org/pages/seek_app) | Point-camera nature ID | Yes, fully offline |
| BirdNET-Pi / BirdNET-Go | Self-hosted 24/7 bird sound monitoring | Yes, your own hardware |

## Contributing

Know a model that belongs here? Open an issue or PR. It qualifies if it (1) does something useful, (2) runs on consumer hardware without a cloud service, and (3) has a working public download. Include: task, input type, model size, runtime, license (code **and** weights), Node SDK status, and download link.