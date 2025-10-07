extends Resource
class_name ProductConfig

@export_enum(
# *** Almacen ***
"almacen/legumbres", 
"almacen/pastas_secas",
"almacen/enlatados_conservas",
"almacen/aderezos",
"almacen/especias",
"almacen/snacks",
# *** Bebidas ***
"bebidas/gaseosas",
"bebidas/gaseosas_chicas",
"bebidas/jugos_aguas",
"bebidas/latas",
"bebidas/licoreria",
# *** Carniceria ***
"carniceria/achuras_embutidos",
"carniceria/carnes_varias",
"carniceria/pescados_mariscos",
"carniceria/pollo_granja",
# *** Desayuno ***
"desayuno/galletitas_bizcochitos_tostadas",
"desayuno/infusiones",
"desayuno/mermeladas_dulces",
"desayuno/cereales_barritas",
"desayuno/chocolates_golosinas",
"desayuno/polvos",
# *** Fiambreria ***
"fiambreria/animal",
"fiambreria/queso",
"fiambreria/snacks_sueltos",
# ***Lacteos ***
"lacteos_congelados/congelados",
"lacteos_congelados/lacteos",
"lacteos_congelados/misc",
# *** Limpieza ***
"limpieza/limpieza_ropa",
"limpieza/limpieza_hogar",
"limpieza/misc",
# *** Mascotas ***
"mascotas/alimento",
"mascotas/higiene",
"mascotas/juguetes_correas",
# *** Panaderia ***
"panaderia/dulces",
"panaderia/panes",
# *** Perfumeria ***
"perfumeria/cuidado_cabello",
"perfumeria/cuidado_diario",
"perfumeria/higiene_personal",	
# *** Verduleria ***
"verduleria/bandejas",
"verduleria/frutas/banana",
"verduleria/frutas/limon",
"verduleria/frutas/mandarina",
"verduleria/frutas/manzana_verde",
"verduleria/frutas/naranja",
"verduleria/frutas/pera",
"verduleria/frutas/tomate",
"verduleria/frutos_secos",
"verduleria/verduras/berenjena",
"verduleria/verduras/calabaza",
"verduleria/verduras/choclo",
"verduleria/verduras/lechuga",
"verduleria/verduras/zanahoria",
) 
var categoria: String

@export_range(0.0, 100.0, 1) var porcentaje: float = 0.0
