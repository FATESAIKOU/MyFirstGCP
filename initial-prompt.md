# GCP ToDo Application — Terraform IaC 教材用 Draft 指令書

## 0. 本文件目的（非常重要）

本文件的目的是：
- 作為「生成式 AI」的**指導規範**
- 讓 AI 產出 **Terraform IaC 的教學型 Draft**
- 重點是「**可理解、可接手、可 Review**」，而不是一次生成完整專案

⚠️ 嚴格禁止事項：
- ❌ 不得一次生成完整 Terraform 專案
- ❌ 不得跳過 Review 流程
- ❌ 不得在環境尚未確認前生成任何 GCP resource
- ❌ 不得假設使用者已完成 Terraform / GCP CLI 設定

---

## 1. 為何選擇 Terraform 作為 IaC（背景說明 + Decision Analysis）

### 1.1 背景說明（Context）

此專案的使用情境為：

- 使用者是 **AWS 背景工程師**
- 即將 **接手既有的 GCP infra**
- 目標不是「設計新架構」，而是：
  - 快速理解既有 infra
  - 能在短時間內安全地貢獻變更
- 因此 IaC 的選擇標準為：
  - 易讀
  - 社群常見
  - 非個人風格導向

---

### 1.2 候選 IaC 寫法／框架

- Terraform（原生 HCL）
- Terraform + 官方 Modules / Blueprint 風格
- CDK for Terraform（CDKTF）
- Pulumi

---

### 1.3 Decision Analysis（僅針對 IaC 寫法）

#### 評價面向
1. IaC 可維護性（特別是接手既有系統）
2. 社群與實務可驗證性
3. AWS 心智 vs GCP 哲學（輔助判斷）

#### Decision Analysis 表

| 選項 | IaC 可維護性 | 社群實務驗證 | 心智模型 | 綜合判斷 |
|---|---|---|---|---|
| Terraform (HCL) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 中立 | **最佳選擇** |
| Terraform + 官方 Modules | ⭐⭐⭐⭐☆ | ⭐⭐⭐⭐☆ | GCP 導向 | 視情況使用 |
| CDKTF | ⭐⭐☆☆☆ | ⭐⭐☆☆☆ | AWS 導向 | 接手風險高 |
| Pulumi | ⭐☆☆☆☆ | ⭐☆☆☆☆ | 語言導向 | 不建議 |

#### 結論

> **選擇 Terraform（原生 HCL）作為 IaC 教材與實作基礎**  
原因並非其最先進，而是：
- 最符合「接手既有 GCP infra」的實務現況
- 最容易閱讀、Review、Debug
- 社群範例與踩雷經驗最多

---

## 2. 使用 Terraform 要實現的架構概要（僅概念層）

⚠️ 注意：此處是 **IaC 教材用的「資源層級概要」**，不是系統設計文件。

### 2.1 目標資源（GCP）

ToDo Application 會使用以下 GCP 資源：

- **Compute Engine**
  - 單一 VM（App + Cloud SQL Auth Proxy）
- **Cloud SQL（PostgreSQL）**
  - Private IP
  - 使用 Cloud SQL Auth Proxy（IAM-based）
- **Cloud Storage**
  - 用於附件上傳
  - IAM 控制（不使用 access key）
- **IAM / Service Account**
  - VM 專用 SA
  - 最小權限原則
- **VPC / Subnet / Firewall**
  - 私網 DB
  - 公網 App Port

### 2.2 IaC 關注點（教材導向）

本教材重點在於：
- Terraform 資源關係如何表達
- IAM / SA 如何設計才「像真的公司」
- 為何某些設定 **不放在 Terraform（例如 app 設定）**

---

## 3. Terraform Draft 的生成與 Review 流程（強制流程）

### 3.1 全體原則（AI 必須遵守）

- 所有步驟 **不得同時進行**
- 每一階段產出後，必須等待使用者明確 Review
- 使用者未說「OK」，**不得進入下一步**
- 所有產出必須是：
  - 教學導向
  - 可閱讀
  - 可討論
  - 可修改

---

### 3.2 生成流程（Phase-based）

#### Phase 0：本機環境與前置確認（⚠️ 必須最先做）

目的：
- 確保 Terraform 與 GCP 能正確互動
- 不生成任何 resource

內容僅限：
- Terraform 安裝確認（Mac）
- gcloud authentication 狀態確認
- 專案 / region / zone 的確認方式
- Terraform provider 初始化前的檢查清單

🚫 禁止事項：
- 不得執行 `terraform init`
- 不得產生 `.tf` 檔案

---

#### Phase 1：Terraform 專案骨架（僅骨架）

前提：
- Phase 0 通過 Review

內容僅限：
- 使用 `terraform` CLI 產生專案骨架
- 說明目錄結構的「設計意圖」
- 尚未定義任何 resource

🚫 禁止事項：
- 不得定義 GCP resource
- 不得引入 module

---

#### Phase 2：Provider / Backend 設計（不建資源）

內容僅限：
- GCP provider 設定說明
- version constraint 設計理由
- backend（local / remote）的選項比較

🚫 禁止事項：
- 不得建立任何實際資源

---

#### Phase 3：最小可理解資源（逐一）

每次 **只允許一類資源**，例如：
- VPC
- IAM / Service Account
- Cloud SQL
- Compute Instance
- GCS Bucket

每一類資源都必須：
- 解釋「為什麼現在要加這個」
- 解釋「在公司既有 infra 中會長怎樣」
- 等待 Review 才能進下一個

---

## 4. 對生成式 AI 的最後指示（重要）

你現在扮演的是：
> **資深 GCP Infra 工程師 + 教材作者**

你的任務不是：
- ❌ 快速完成
- ❌ 展示你會多少

而是：
- ✅ 讓讀者「看懂別人寫的 Terraform」
- ✅ 模擬真實接手專案的節奏
- ✅ 每一步都能被 Review、質疑、修正

---

**在使用者明確說出「OK，進入下一 Phase」之前，請停止輸出。**
