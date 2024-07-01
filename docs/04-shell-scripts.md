# 세션 04: 셸 스크립트 작업

이 세션에서는 [GitHub Copilot](https://docs.github.com/ko/copilot/overview-of-github-copilot/about-github-copilot-business) 기능을 활용해 파워셸 스크립트와 Bash 셸 스크립트를 작성해 보겠습니다.

> [GitHub Codespaces](https://docs.github.com/ko/codespaces/overview) 또는 [Visual Studio Code](https://code.visualstudio.com/?WT.mc_id=dotnet-121695-juyoo) 환경에서 작업하는 것을 기준으로 합니다.

## 04-1: 데이터 다운로드 스크립트 작성하기 (파워셸)

1. 터미널을 열고 아래 명령어를 차례로 실행시켜 리포지토리의 루트 디렉토리로 이동합니다.

    ```bash
    # GitHub Codespaces
    REPOSITORY_ROOT=$CODESPACE_VSCODE_FOLDER
    cd $REPOSITORY_ROOT

    # bash/zsh
    REPOSITORY_ROOT=$(git rev-parse --show-toplevel)
    cd $REPOSITORY_ROOT

    # PowerShell
    $REPOSITORY_ROOT = git rev-parse --show-toplevel
    cd $REPOSITORY_ROOT
    ```

1. 아래 명령어를 실행시켜 `Get-MelonChartData.ps1` 파일을 생성합니다.

    ```bash
    # bash/zsh
    cd $REPOSITORY_ROOT/workshop
    touch Get-MelonChartData.ps1

    # PowerShell
    cd $REPOSITORY_ROOT/workshop
    New-Item -Path Get-MelonChartData.ps1 -ItemType File
    ```

1. `Get-MelonChartData.ps1` 파일을 열고 `CTRL`+`I` 키 또는 `CMD`+`I` 키를 눌러 GitHub Copilot Chat 창을 활성화 시킵니다. 그리고 아래 프롬프트를 입력합니다.

    ```text
    Create a PowerShell script:
    
    - There are 2 input parameters: $Url and $FilePath
    - It should download the data from the URL and save it to the file path
    - Read the data from the saved file, group the records by artist and order them by the song in ascending order
    - Output the result in a table format
    ```

   그러면 아래와 비슷한 코드를 자동으로 만들어 줄 것입니다. 아래 코드를 참고해서 `Get-MelonChartData.ps1` 파일을 수정합니다.

    ```powershell
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,
    
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    # Download the data from the URL and save it to the file path
    $(Invoke-WebRequest -Uri $Url).Content | Out-File $FilePath -Force
    
    # Read the data from the saved file
    $data = Get-Content -Path $FilePath
    
    # Group the records by artist and order them by the song in ascending order
    $groupedData = $($data | ConvertFrom-Json).items | Group-Object -Property artist | ForEach-Object {
        $_.Group | Sort-Object -Property title
    }
    
    # Output the result in a table format
    $groupedData | Format-Table -AutoSize
    ```

1. 아래 명령어를 실행시켜 `Get-MelonChartData.ps1` 스크립트를 실행합니다.

    ```bash
    # bash/zsh
    cd $REPOSITORY_ROOT/workshop
    ([[ "$(uname)" == "Linux" ]] && date=$(date -u -d '+9 hours' +"%Y%m%d")) || ([[ "$(uname)" == "Darwin" ]] && date=$(date -u -v+9H +"%Y%m%d"))
    url="https://raw.githubusercontent.com/aliencube/MelonChart.NET/main/data/top100-$date.json"
    pwsh ./Get-MelonChartData.ps1 -Url $url -FilePath ./top100.json

    # PowerShell
    cd $REPOSITORY_ROOT/workshop
    $date = (Get-Date).ToUniversalTime().AddHours(9).ToString("yyyyMMdd")
    $url = "https://raw.githubusercontent.com/aliencube/MelonChart.NET/main/data/top100-$date.json"
    ./Get-MelonChartData.ps1 -Url $url -FilePath "top100.json"
    ```

## 04-2: 파워셸 스크립트를 Bash 셸 스크립트로 변환하기

1. 앞서 작성한 `Get-MelonChartData.ps1` 파일을 열고 전체 내용을 선택합니다. GitHub Copilot Chat을 열어 아래와 입력하여 Bash 셸 스크립트로 변환합니다.

    ```text
    @workspace /fix Convert this PowerShell script into a Bash shell script by taking named arguments
    ```

   그러면 아래와 비슷한 코드를 자동으로 만들어 줄 것입니다. 아래 코드를 참고해서 `get-melonchartdata.sh` 파일을 생성합니다.

    ```bash
    #!/bin/bash
    
    # Assign named arguments to variables
    for arg in "$@"
    do
        case $arg in
            --url=*)
            URL="${arg#*=}"
            shift # Remove --url= from processing
            ;;
            --filepath=*)
            FILEPATH="${arg#*=}"
            shift # Remove --filepath= from processing
            ;;
        esac
    done
    
    # Check if URL and FILEPATH variables are set
    if [ -z "$URL" ] || [ -z "$FILEPATH" ]; then
        echo "Both --url and --filepath arguments are required."
        exit 1
    fi
    
    # Download the data from the URL and save it to the file path
    curl "$URL" > "$FILEPATH"
    
    # Read the data from the saved file and process it
    # Assuming the data is in JSON format and jq is installed for JSON processing
    # Group the records by artist and order them by the song in ascending order
    jq -r '.items | group_by(.artist) | .[] | sort_by(.title) | .[] | @base64' "$FILEPATH" |
    while read -r line; do
        echo $line | base64 --decode | jq -r '[.artist, .title] | @tsv'
    done | column -t
    ```

1. 아래 명령어를 통해 방금 생성한 `get-melonchartdata.sh` 스크립트를 실행합니다.

    ```bash
    cd $REPOSITORY_ROOT/workshop
    chmod +x ./get-melonchartdata.sh

    ([[ "$(uname)" == "Linux" ]] && date=$(date -u -d '+9 hours' +"%Y%m%d")) || ([[ "$(uname)" == "Darwin" ]] && date=$(date -u -v+9H +"%Y%m%d"))
    url="https://raw.githubusercontent.com/aliencube/MelonChart.NET/main/data/top100-$date.json"
    ./get-melonchartdata.sh --url=$url --filepath="top100.json"
    ```

## 04-3: 숙제

- 아래 문화관광부 공연정보 API를 활용해서 가장 최근에 열린 공연 정보(제목, 날짜, 장소)를 가져오는 Bash 셸 스크립트를 GitHub Copilot을 이용해 만들어 보세요.
  - [공연정보 API](https://www.culture.go.kr/data/openapi/openapiView.do?id=597)

  > **NOTE**: API 키를 가져오기 위해 [문화공공데이터 오픈API](https://www.culture.go.kr/data/page/guide/openapiGuide.do) 사이트에 가입하고 API 키를 발급받아야 합니다.

---

축하합니다! GitHub Copilot을 통해 다양한 파워셸 스크립트 및 Bash 셸 스크립트를 작성하는 방법에 대해 알아봤습니다.
