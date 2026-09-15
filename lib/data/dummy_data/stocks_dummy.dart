class StocksDummy {
  static final List<Map<String, dynamic>> data = [
    {
      "id": 0,
      "product": "Turanza T005A",
      "width": "185",
      "height": "65",
      "ring": "R15",
      "stock": "3 pcs",
      "status": "Urgent",
      "lastRestock": "10 Feb 2025",
      "batches": [
        {
          "code": "0314",
          "date": "Mar 2026",
          "quantity": {"number": 2, "type": "pcs"},
          "age": {"year": 2, "unit": "thn"},
          "prices": {"piece": 900000, "total": 1800000},
        },
        {
          "code": "0325",
          "date": "Mar 2026",
          "quantity": {"number": 1, "type": "pcs"},
          "age": {"year": 1, "unit": "thn"},
          "prices": {"piece": 900000, "total": 900000},
        },
      ],
    },
    {
      "id": 1,
      "product": "Potenza RE004",
      "width": "185",
      "height": "65",
      "ring": "R15",
      "stock": "8 pcs",
      "status": "Warning",
      "lastRestock": "8 Feb 2025",
      "batches": [
        {
          "code": "0314",
          "date": "Mar 2026",
          "quantity": {"number": 2, "type": "pcs"},
          "age": {"year": 2, "unit": "thn"},
          "prices": {"piece": 500000, "total": 1000000},
        },
        {
          "code": "0325",
          "date": "Mar 2026",
          "quantity": {"number": 1, "type": "pcs"},
          "age": {"year": 1, "unit": "thn"},
          "prices": {"piece": 500000, "total": 900000},
        },
      ],
    },
  ];
}
