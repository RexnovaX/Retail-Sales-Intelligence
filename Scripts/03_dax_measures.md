# DAX Measures & Calculated Columns

This document details the Data Analysis Expressions (DAX) used in the Power BI data model. Each measure and calculated column was designed to transform raw transactional data into actionable financial, operational, and inventory intelligence.

---

## 💰 1. Core Financial Measures

These measures calculate the actual revenue, costs, and profit margins of the business, providing a clear picture of the company's financial health.

### Real Revenue (Ingresos Reales)
*Calculates the total gross income by multiplying the quantity of items sold by their retail price at the time of the transaction.*
```dax
Ingresos_Reales = 
SUMX(
    'public detalle_ventas', 
    'public detalle_ventas'[cantidad] * RELATED('public productos'[precio_venta])
)
```

### Total Production Cost (Costo Total de Produccion)
*Calculates the total gross income by multiplying the quantity of items sold by their retail price at the time of the transaction.*
```dax
Costo Total de Produccion = 
SUMX(
    'public detalle_ventas',
    'public detalle_ventas'[cantidad] * RELATED('public productos'[costo_produccion])
)
```

### Net Profit (Ganancias)
*Determines the actual profit by subtracting the total production costs from the real revenue.*
```dax
Ganancias = [Ingresos_Reales] - [Costo Total de Produccion]
```

### Profit Margin Percentage (Margen %)
*Calculates the percentage of revenue that translates into profit, a key metric for pricing strategy.*
```dax
Margen % = DIVIDE([Ganancias], [Ingresos_Reales], 0)
```

### Average Ticket (Ticket Promedio)
*Calculates the Average Order Value (AOV), showing how much an average customer spends per transaction.*
```dax
Ticket Promedio = DIVIDE([Ingresos_Reales], [Ventas Totales], 0)
```

## 2. Inventory & Forecasting Measures

These measures evaluate current stock values, capital tied up in inventory, and estimate operational autonomy to prevent stockouts.

### Total Sales Volume (Ventas Totales)
*Counts the total number of individual transactions/orders processed.*
```dax
Ventas Totales = COUNTROWS('public ventas')
```

### Operating Days (Dias de Operacion)
*Determines the total active lifespan of the dataset by calculating the days between the first and last recorded sale.*
```dax
Dias de Operacion = 
DATEDIFF(
    MIN('public ventas'[fecha_hora]), 
    MAX('public ventas'[fecha_hora]), 
    DAY
) + 1
```

### Average Daily Sales (Venta Diario Promedio)
*Calculates the average number of transactions per day to establish a baseline for daily operations.*
```dax
Venta Diario Promedio = DIVIDE([Ventas Totales], [Dias de Operacion], 0)
```

### Days of Inventory (Dias de Inventario)
*Estimates how many days the total current stock will last based on the historical daily average sales.*
```dax
Dias de Inventario = DIVIDE(SUM('public productos'[stock_actual]), [Venta Diaria Promedio], 0)
```

### Days of Autonomy (Dias de Autonomia)
*A more sensitive inventory metric that estimates stock longevity based specifically on a 30-day rolling average.*
```dax
Dias de Autonomia = 
VAR VentasTotales = [Ventas Totales]
VAR VentaDiariaPromedio = DIVIDE(VentasTotales, 30, 0) 
VAR StockActual = SUM('public productos'[stock_actual])
RETURN
DIVIDE(StockActual, VentaDiariaPromedio, 0)
```

### Current Display Value - Cost (Invertido / Valor de la vitrina)
*Calculates the total capital currently tied up in the physical inventory based on production costs.*
```dax
Invertido = 
SUMX(
    'public productos',
    'public productos'[stock_actual] * 'public productos'[costo_produccion]
)

Valor de la vitrina = 
SUMX(
    'public productos',
    'public productos'[stock_actual] * 'public productos'[costo_produccion]
)
```

### Potential Display Value - Revenue (Valor potencial)
*Projects the total expected revenue if all current inventory is sold at the designated retail price.*
```dax
Valor potencial = 
SUMX(
    'public productos',
    'public productos'[stock_actual] * 'public productos'[precio_venta]
)
```

### Expected Profit (Ganancia Esperada)
*Forecasts the net profit locked within the current inventory sitting in the display cases.*
```dax
Ganancia Esperada = [Valor potencial] - [Invertido]
```

## 3. Calculated Columns: Products Table (public productos)

These columns add dimensional attributes to the products, enabling smart ranking and automated inventory alerts.

### Absolute Profit Margin (Margen de Ganancias)
*Calculates the absolute monetary profit generated per single unit of a product.*
```dax
Margen de Ganancias = 'public productos'[precio_venta] - 'public productos'[costo_produccion]
```

### Dynamic Product Rating (Valoracion Panaderia Real)
*A dynamic 5-star rating system that classifies products based on their percentile performance in both revenue generation and sales volume compared to the rest of the catalog. This identifies top performers and dead weight.*
```dax
Valoracion Panaderia Real = 
VAR Estrella_Llena = "⭐" 
VAR Estrella_Vacia = UNICHAR(9734) 

-- 1. CAPTURE CURRENT PRODUCT VALUES
VAR vGananciaBruta = [Ganancias]
VAR vVentasCant = [Ventas Totales]
VAR vMargenPorcentual = [Margen %]

-- 2. CALCULATE PERCENTILES FOR THRESHOLDS
VAR TablaProductos = ALLSELECTED('public productos')

-- Top 20% in revenue generation 
VAR TopGananciaDinero = PERCENTILEX.INC(TablaProductos, [Ganancias], 0.80) 

-- Top 20% in sales volume 
VAR TopVolumenVentas = PERCENTILEX.INC(TablaProductos, [Ventas Totales], 0.80)

-- Medians for mid-tier classification
VAR MediaGanancia = PERCENTILEX.INC(TablaProductos, [Ganancias], 0.50)
VAR MediaVentas = PERCENTILEX.INC(TablaProductos, [Ventas Totales], 0.50)

RETURN
SWITCH(TRUE(),
    -- ⭐⭐⭐⭐⭐ TIER 1: LEADERS (Top tier in either revenue or volume)
    vGananciaBruta >= TopGananciaDinero || vVentasCant >= TopVolumenVentas, 
        REPT(Estrella_Llena, 5),
    
    -- ⭐⭐⭐⭐ TIER 2: STRONG PERFORMERS (Above average in both metrics)
    vGananciaBruta >= MediaGanancia && vVentasCant >= MediaVentas, 
        REPT(Estrella_Llena, 4) & Estrella_Vacia,
    
    -- ⭐⭐⭐ TIER 3: AVERAGE (Above average in at least one metric)
    vGananciaBruta >= MediaGanancia || vVentasCant >= MediaVentas, 
        REPT(Estrella_Llena, 3) & REPT(Estrella_Vacia, 2),
    
    -- ⭐⭐ TIER 4: UNDERPERFORMERS (Below average, but active sales)
    vVentasCant > 0, 
        REPT(Estrella_Llena, 2) & REPT(Estrella_Vacia, 3),
    
    -- ⭐ TIER 5: DEAD WEIGHT (Zero to negligible movement)
    REPT(Estrella_Llena, 1) & REPT(Estrella_Vacia, 4)
)
```

### Smart Stock Status (Estado Stock Inteligente)
*An automated alert system that categorizes inventory levels into actionable statuses based on the calculated Days of Inventory, aiding in daily production planning.*
```dax
Estado Stock Inteligente = 
VAR DiasRestantes = [Dias de Inventario]
RETURN
SWITCH(TRUE(),
    DiasRestantes <= 0.5, "🔴 Restock (Under 0.5 Days)",
    DiasRestantes >= 3.1, "🔴 Overstocked",
    DiasRestantes <= 1.5, "🟡 Monitor (1 Day)",
    "🟢 Sufficient"
)
```

### Rounded Daily Average Sales (Venta promedio diaria)
*Rounds the average daily sales for cleaner UI presentation.*
```dax
Venta promedio diaria = ROUND([Venta Diario Promedio], 0)
```

### Rounded Sufficient Stock Days (Stock suficiente Dias)
*Rounds the inventory days for cleaner UI presentation.*
```dax
Stock suficiente Dias = ROUND([Dias de Inventario], 0)
```

## 4. Calculated Columns: Sales Table (public ventas)

Time intelligence columns designed to enable temporal analysis and peak-hour detection.

### Sale Hour (Hora Venta)
*Extracts the specific hour from the transaction timestamp to analyze peak operating windows.*
```dax
Hora Venta = HOUR('public ventas'[fecha_hora])
```

### Day of the Week (Día)
*Extracts and capitalizes the day of the week from the transaction timestamp to identify high-traffic days.*
```dax
Día = 
VAR Dia = FORMAT('public ventas'[fecha_hora], "dddd")
RETURN
UPPER(LEFT(Dia, 1)) & RIGHT(Dia, LEN(Dia) - 1)
```