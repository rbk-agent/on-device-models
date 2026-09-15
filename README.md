# On-Device AI Model Index

Small AI models that identify **plants, birds, animals, and sounds** — from photos or audio — and are small enough to run **offline on phones, Raspberry Pis, and laptops**. No cloud, no API keys, no network calls.

**What belongs here:** a model that (1) identifies something in nature or sound, (2) runs on consumer hardware without a cloud service, and (3) has a working public download and license.

## The Index

| # | Model | Identifies | Input | Size | License |
|---|-------|-----------|-------|------|---------|
| 1 | [BirdNET V2.4](#1-birdnet-v24) | 6,000+ bird species | Audio | ~50 MB | MIT (code) / CC BY-NC-SA 4.0 (models) |
| 2 | [Google Perch](#2-google-perch) | ~15,000 bird species | Audio | Laptop-class | Apache-2.0 |
| 3 | [iNaturalist Vision (Small)](#3-inaturalist-vision-small) | Plants, animals, fungi (~500 taxa) | Photo | ~22 MB | MIT |
| 4 | [MegaDetector V6](#4-megadetector-v6) | Animals, people, vehicles in camera images | Photo | 2.3M params (compact) | MIT (select variants) |
| 5 | [YAMNet](#5-yamnet) | 521 everyday sounds, incl. musical instruments | Audio | ~4 MB | Apache-2.0 |
| 6 | [musicnn](#6-musicnn) | Music tags: genre, instruments, mood, tempo | Audio | A few MB | ISC |
| 7 | [Pl@ntNet-300K](#7-plntnet-300k) | Train your own plant classifier | Dataset + code | — | BSD-2 (code) / CC-BY-4.0 (dataset) |

Quick picks:

- **Birds by sound** → BirdNET (phone/Pi), Perch (higher accuracy, laptop)
- **Plants from photos** → iNaturalist Vision, or train your own with Pl@ntNet-300K
- **"Is there an animal in this photo?"** → MegaDetector (detects, doesn't name species — pair with a classifier)
- **What instrument am I hearing?** → YAMNet (general sounds) or musicnn (music-specific)

---

## 1. BirdNET V2.4

**Identifies 6,000+ bird species from audio**, worldwide. The standard for on-device bird sound ID — runs comfortably on a Raspberry Pi, even a Pi Zero 2 W.

- **How it works:** sliding-window spectrograms → species list with confidence scores. 3-second chunks of audio in, ranked species out.
- **Numbers:** 6,522 classes (birds + some non-bird species), 50.5 MB FP32, 0.826 GFLOPs per inference. Older V2.2 is 21.3 MB if you need smaller.
- **Runtime:** TensorFlow Lite. CPU is fine.
- **License:** ⚠️ split — the [code](https://github.com/birdnet-team/BirdNET-Analyzer) is MIT, but the **model weights are CC BY-NC-SA 4.0** (non-commercial). Education and research count as non-commercial. Don't ship these in a paid app.
- **Get it:** [BirdNET-Analyzer](https://github.com/birdnet-team/BirdNET-Analyzer) · [model downloads](https://birdnet-team.github.io/BirdNET-Analyzer/models.html)
- **Ready-made deployments:** [BirdNET-Pi](https://github.com/Nachtzuster/BirdNET-Pi) (24/7 Pi monitoring station), [BirdNET-Go](https://github.com/tphakala/birdnet-go) (real-time web UI for Pi/RTSP cameras).

## 2. Google Perch

Google's newer bird vocalization model. **Higher accuracy than BirdNET, global coverage (~15,000 species)**, and outputs embeddings you can use to build custom classifiers with just a handful of examples (few-shot).

- **How it works:** audio in → species scores + a 1280-d embedding. Fine-tune or few-shot-match against your own labeled clips.
- **Size:** laptop-class (larger than BirdNET; not phone-first). Community [TFLite/ONNX ports](https://huggingface.co/justinchuby/Perch-onnx) exist and are shrinking it.
- **Runtime:** TensorFlow/JAX; ONNX and TFLite ports available.
- **License:** Apache-2.0 — including the weights (more permissive than BirdNET's).
- **Get it:** [google-research/perch](https://github.com/google-research/perch) · [Hugging Face](https://huggingface.co/cgeorgiaw/Perch) · [Kaggle](https://www.kaggle.com/models/google/bird-vocalization-classifier)

## 3. iNaturalist Vision (Small)

iNaturalist's published on-device nature classifier — **plants, animals, fungi from photos**, fully offline. The same family of models that powers the [Seek app](https://www.inaturalist.org/pages/seek_app).

- **Numbers:** ~22 MB int8-quantized TFLite (also CoreML for iOS), trained on ~500 taxa, plus a 0.7 MB geolocation model that down-ranks species unlikely at your GPS point. Taxonomy files included.
- **Runtime:** TensorFlow Lite / CoreML.
- **Caveat:** iNat's full production model (72,000+ taxa) is **private** — these published "Small" models are the offline demo/test tier. Still the best openly downloadable starting point for offline nature ID.
- **License:** MIT.
- **Get it:** [inaturalist/model-files](https://github.com/inaturalist/model-files) (releases page has the TFLite/CoreML/taxonomy bundles)

## 4. MegaDetector V6

Microsoft AI for Good's camera-trap model. **Detects animals, people, and vehicles in photos** — not species names, just "something is here" with bounding boxes. Built for filtering empty camera-trap images, which makes it a great front-end stage: detect → crop → hand to a species classifier.

- **Numbers:** compact variant `MDV6-yolov10-c` is 2.3M params, ~2% the size of V5, runs on CPU. Larger YOLOv9/v10 and RT-DETR variants in the Model Zoo.
- **Runtime:** PyTorch, CPU-friendly compact variants. Runs on solar field units, so consumer hardware is easy.
- **License:** ⚠️ varies by variant — pick `MDV6-mit-yolov9-c` for the MIT-licensed one; others are Apache-2.0 or AGPL-3.0. Check the Model Zoo before shipping.
- **Get it:** [microsoft/MegaDetector](https://github.com/microsoft/MegaDetector) · [Model Zoo](https://microsoft.github.io/MegaDetector/model_zoo/) · framework: [PyTorch-Wildlife](https://github.com/microsoft/Pytorch-Wildlife)

## 5. YAMNet

Google's tiny general-purpose sound classifier: **521 everyday sound classes from the AudioSet ontology** — including musical instruments (guitar, piano, drums, violin…), machinery, animals, speech, and weather.

- **Numbers:** MobileNetV1 backbone, 0.92M params, ~4 MB TFLite. 16 kHz mono waveform in, frame-level scores out. Fast enough for real-time on phones.
- **Best use:** a grab-bag "what am I hearing?" model, and the standard **transfer-learning base** for custom audio classifiers — retrain the last layer with a few hundred clips of your own sounds.
- **License:** Apache-2.0.
- **Get it:** [TF Hub](https://tfhub.dev/google/yamnet/1) · [TFLite version](https://github.com/antonyharfield/tflite-models-audioset-yamnet) · [Kaggle](https://www.kaggle.com/models/google/yamnet)

## 6. musicnn

Pre-trained music audio taggers: **genre, instruments, mood, tempo** (trained on MagnaTagATune and the Million Song Dataset). Ask "what's in this track" and get tags like `guitar`, `piano`, `drums`, `techno`, `ambient`, `fast`.

- **Numbers:** small CNNs (a few MB); several variants (MSD, MTT). Runs on CPU, per-3s-window tagging.
- **Best use:** music/instrument tagging, or as a feature extractor for music ML.
- **License:** ISC (permissive, MIT-equivalent).
- **Get it:** [jordipons/musicnn](https://github.com/jordipons/musicnn) (`pip install musicnn`)

## 7. Pl@ntNet-300K

Not a model — a **research-grade plant photo dataset + PyTorch training code** (NeurIPS 2021), for training your own plant classifier. High label ambiguity and a long-tailed distribution, so models trained on it resemble real-world conditions.

- **What you get:** ~300K plant images across ~1,000 species, with train/val/test splits, plus training/eval code.
- **License:** code BSD-2-Clause, dataset CC-BY-4.0.
- **Get it:** [plantnet/PlantNet-300K](https://github.com/plantnet/PlantNet-300K) · [dataset on Zenodo](https://zenodo.org/records/4726653)

---

## Apps you can try today

These products use the same model families, if you want to feel the UX before building:

| App | What it does | Offline? |
|-----|-------------|----------|
| [Merlin Bird ID](https://merlin.allaboutbirds.org/) (Cornell) | Bird photo ID + live sound ID | Photo ID yes, Sound ID partially |
| [Seek by iNaturalist](https://www.inaturalist.org/pages/seek_app) | Point-camera nature ID | Yes, fully offline |
| BirdNET-Pi / BirdNET-Go | Self-hosted 24/7 bird sound monitoring | Yes, your own hardware |

## Contributing

Know a model that belongs here? Open an issue or PR. It qualifies if it identifies something in nature or sound, runs on consumer hardware without a cloud service, and has a working public download. Include: task, input type, model size, runtime, license (code **and** weights), and download link.