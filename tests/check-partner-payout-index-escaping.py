#!/usr/bin/env python3
from pathlib import Path


view = Path("partner/views/partner-payout/index.php")
source = view.read_text()

status_column = source.split("'label' => 'Status'", 1)[1].split("],", 1)[0]
amount_column = source.split("'label' => 'Amount'", 1)[1].split("],", 1)[0]

assert "'format' => 'raw'" not in status_column, (
    "Partner payout status must not render stored status text as raw HTML."
)
assert "'format' => 'text'" in status_column, (
    "Partner payout status should use Yii text formatting so values are encoded."
)
assert "($data->status ?? '')" in status_column, (
    "Partner payout status should handle missing status values without notices."
)
assert "'format' => 'raw'" not in amount_column, (
    "Partner payout amount should not require raw HTML rendering."
)

print("Partner payout index encodes payout grid values.")
