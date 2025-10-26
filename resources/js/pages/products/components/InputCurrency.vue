<script setup lang="ts">
import { ref, computed, watch } from "vue"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger
} from "@/components/ui/dropdown-menu"

// Valor do input
const price = ref<number | null>(null)
const display = ref<string>("")

// Moeda selecionada
const currency = ref("BRL")

// Lista de moedas
const currencies = [
  { code: "BRL", symbol: "R$" },
  { code: "USD", symbol: "$" },
  { code: "EUR", symbol: "€" },
  { code: "GBP", symbol: "£" },
  { code: "JPY", symbol: "¥" },
]

// Formata o número como moeda
function formatPrice(value: string | number) {
  if (!value && value !== 0) return ""
  const num = typeof value === "string" ? Number(value.replace(/\D/g, "")) : value
  return new Intl.NumberFormat("pt-BR", {
    style: "currency",
    currency: currency.value,
  }).format(num / 100)
}

// Atualiza display enquanto digita
watch(price, (newVal) => {
  display.value = formatPrice(newVal || 0)
})

function onInput(e: Event) {
  const target = e.target as HTMLInputElement
  const raw = target.value.replace(/\D/g, "")
  price.value = Number(raw)
  display.value = formatPrice(raw)
}

function selectCurrency(code: string) {
  currency.value = code
  display.value = formatPrice(price.value || 0)
}
</script>

<template>
  <div class="w-full max-w-sm">
    <Label for="price">Preço do Produto</Label>
    <div class="relative mt-1 flex items-center">
      <Input
        id="price"
        type="text"
        :value="display"
        @input="onInput"
        placeholder="0,00"
        class="pr-20 text-lg font-medium border-gray-300 focus:border-blue-500 focus:ring-2 focus:ring-blue-300 transition-colors rounded-lg shadow-sm"
      />
      <!-- Dropdown de moedas -->
      <DropdownMenu>
        <DropdownMenuTrigger as-child>
          <Button
            variant="outline"
            class="absolute right-1 top-1/2 -translate-y-1/2 text-sm px-3 h-8"
          >
            {{ currency }}
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end">
          <DropdownMenuItem
            v-for="curr in currencies"
            :key="curr.code"
            @click="selectCurrency(curr.code)"
          >
            {{ curr.code }} — {{ curr.symbol }}
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </div>
  </div>
</template>

<style scoped>
input:focus {
  outline: none;
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.5);
}
</style>
