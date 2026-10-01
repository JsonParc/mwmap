$p = "C:\Users\" + [char]0xBC15 + [char]0xC9C0 + [char]0xBBFC + "\OneDrive\" + [char]0xBC14 + [char]0xD0D5 + " " + [char]0xD654 + [char]0xBA74 + "\mwmap\indexbh.js"
$c = [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8)
Write-Host "File length: $($c.Length)"

# All remaining Chinese -> Korean replacements
$pairs = @(
    @{o='本站按'+[char]0x201c+'现状'+[char]0x201d+'和'+[char]0x201c+'可用状态'+[char]0x201d+'提供。在适用法律允许的范围内，运营者不对因依赖本站数据、网站中断、数据丢失或第三方内容造成的间接或附带损失负责。 本条款不排除法律不得限制或排除的责任。'; n='이 사이트는 "있는 그대로" 및 "사용 가능한 상태"로 제공됩니다. 적용 법률이 허용하는 범위 내에서, 운영자는 이 사이트 데이터 의존, 사이트 중단, 데이터 손실 또는 제3자 콘텐츠로 인한 간접적·부수적 손해에 대해 책임을 지지 않습니다. 본 조항은 법률상 제한하거나 배제할 수 없는 책임을 배제하지 않습니다.'},
    @{o='变更'; n='변경'},
    @{o='功能、数据来源、托管方式或法律要求变化时，本站可能更新这些条款，并在本法律中心标注最新日期。'; n='기능, 데이터 출처, 호스팅 방식 또는 법적 요구사항이 변경될 때 이 사이트는 해당 약관을 업데이트하고 이 법률 센터에 최신 날짜를 표시할 수 있습니다.'},
    @{o='游戏相关内容'; n='게임 관련 콘텐츠'},
    @{o='地图名称、地图缩略图、地形、空气墙和出生点等内容全部或部分来源于、提取自或派生自《Modern Warships》。 相关游戏素材、数据结构、商标及其他权利归 Artstorm FZE 或相应许可方所有。本站对这些内容不作原创权利主张。'; n='지도 이름, 지도 섬네일, 지형, 공기벽, 스폰 위치 등의 콘텐츠는 전부 또는 일부가 《Modern Warships》에서 유래·추출·파생된 것입니다. 관련 게임 소재, 데이터 구조, 상표 및 기타 권리는 Artstorm FZE 또는 해당 라이선서가 소유합니다. 이 사이트는 이러한 콘텐츠에 대한 원창작 권리를 주장하지 않습니다.'},
    @{o='本站原创部分'; n='이 사이트의 원창작 부분'},
    @{o='除另有标注外，本站维护者仅对自行编写的程序代码、原创文字及可视化编排保留相应权利； 这不会改变底层游戏素材的权利归属，也不限制权利人依法行使权利。'; n='별도 표시가 없는 한, 이 사이트 관리자는 직접 작성한 프로그램 코드, 원창작 텍스트, 시각화 편집에 대한 권리만을 보유합니다. 이는 기반 게임 소재의 권리 귀속을 변경하거나 권리자가 법에 따라 권리를 행사하는 것을 제한하지 않습니다.'},
    @{o='权利通知与下架'; n='권리 통지 및 내리기'},
    @{o='如你是相关权利人并认为本站内容侵权，请提供权利证明、具体内容位置、请求采取的措施及有效联系方式。 运营者核实后会采取限制访问、更正或移除等适当措施。'; n='관련 권리자로서 이 사이트의 콘텐츠가 권리를 침해한다고 판단되면, 권리 증명, 구체적인 콘텐츠 위치, 요청 조치 및 유효한 연락처를 제공해 주세요. 운영자가 확인 후 접근 제한, 수정 또는 제거 등 적절한 조치를 취할 것입니다.'},
    @{o='权利人官方资料'; n='권리자 공식 자료'},
    @{o='Artstorm 创作者指南'; n='Artstorm 크리에이터 가이드'},
    @{o='Artstorm 服务条款'; n='Artstorm 서비스 약관'},
    @{o='Artstorm 隐私政策'; n='Artstorm 개인정보 처리방침'},
    @{o='非官方玩家工具'; n='비공식 플레이어 도구'},
    @{o='· 与 Artstorm 无隶属、授权、赞助或背书关系 · 游戏相关权利归各自权利人'; n='· Artstorm과 소속·라이선스·후원·보증 관계 없음 · 게임 관련 권리는 해당 권리자에게 있음'},
    @{o='站点信息'; n='사이트 정보'},
    @{o='声明'; n='안내문'},
    @{o='关闭法律信息'; n='법률 정보 닫기'},
    @{o='关闭'; n='닫기'},
    @{o='法律信息章节'; n='법률 정보 섹션'},
    @{o='最后更新：'; n='마지막 업데이트: '},
    @{o='。此页面用于透明说 明，不构成法律意见，也不能替代权利人的书面许可。'; n=' 이 페이지는 투명성을 위한 안내이며, 법적 조언을 구성하거나 권리자의 서면 허가를 대체하지 않습니다.'},
    @{o='地形显示设置'; n='지형 표시 설정'},
    @{o='俯视'; n='위에서 내려다보며'},
    @{o='空气墙边界'; n='공기벽 경계'},
    @{o='航段越出空气墙'; n='항로가 공기벽을 벗어남'},
    @{o='航段被陆地阻断'; n='항로가 육지에 의해 차단됨'},
    @{o='这里不是可通行的水面'; n='이곳은 항행 가능한 수면이 아닙니다'},
    @{o='分析舰位只能放在空气墙内的可航行水面'; n='함선 위치 분석은 공기벽 내 항행 가능한 수면에만 배치할 수 있습니다'},
    @{o='fwidth 让等高线在远处也保持大致一样粗，避免摩尔纹。'; n='fwidth allows contour lines to maintain roughly the same thickness at distance, avoiding moire patterns.'},
    @{o='// 保持采样格距'; n='// maintain sampling grid distance'},
    @{o='m/格'; n='m/격'}
)

$count = 0
foreach ($pair in $pairs) {
    if ($c.Contains($pair.o)) {
        $c = $c.Replace($pair.o, $pair.n)
        $count++
        Write-Host "Replaced: $($pair.n.Substring(0, [Math]::Min(20, $pair.n.Length)))..."
    } else {
        Write-Host "NOT FOUND: $($pair.n.Substring(0, [Math]::Min(20, $pair.n.Length)))..."
    }
}

[System.IO.File]::WriteAllText($p, $c, [System.Text.Encoding]::UTF8)
Write-Host "Done. $count replacements made."

# Check remaining
$remaining = [System.Text.RegularExpressions.Regex]::Matches($c, '[\u4e00-\u9fff]')
Write-Host "Remaining Chinese chars: $($remaining.Count)"
