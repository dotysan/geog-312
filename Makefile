SHELL:= bash
PY:= python3.11
VENV:= .venv

FIONA_VER:= 1.10.*
FOLIUM_VER:= 0.17.*
GEOPANDAS_VER:= 1.0.*

vb:= $(VENV)/bin/
sp:= $(VENV)/lib/$(PY)/site-packages/

define vrun
	source $(vb)activate && $(1)
endef

define pip_inst_pkg
$(sp)$(1): $(vb)pip
	$(call vrun,pip --require-virtualenv \
	  install $(1)==$($2))
endef

.PHONY: requirements
.PHONY: fiona
.PHONY: folium
.PHONY: geopandas
.PHONY: clean

requirements: $(vb)pip requirements.txt
	$(call vrun,pip --require-virtualenv \
	  install --requirement=requirements.txt)

fiona: $(sp)fiona
$(eval $(call pip_inst_pkg,fiona,FIONA_VER))

folium: $(sp)folium
$(eval $(call pip_inst_pkg,folium,FOLIUM_VER))

geopandas: $(sp)geopandas
$(eval $(call pip_inst_pkg,geopandas,GEOPANDAS_VER))

$(vb)pip: $(vb)activate
	$(call vrun,pip --require-virtualenv \
	  list --format=freeze \
	  |grep -oE '^[^=]+' \
	  |xargs pip install --upgrade)

$(vb)activate:
	$(PY) -m venv $(VENV)

clean:
	rm -fr $(VENV)
