<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { dashboard } from '@/routes';
import { Input } from '@/components/ui/input';
import { type BreadcrumbItem } from '@/types';
import { Head, usePage, Link, Form } from '@inertiajs/vue3';
import { computed } from 'vue';
import { Button } from '@/components/ui/button';

interface Product {
    id: number; 
    name: string;
    description: string;
}

interface Props {
    product: Product;
}

const props = defineProps<Props>()
// const produts = computed()
const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Editar Produto',
        href: '/products/edit',
    },
];
</script>

<template>

    <Head title="Editar Produto " />

    <AppLayout :breadcrumbs="breadcrumbs" :href="`/products/${props.product.id}/edit`">
        <div class="p-4">
            <h1>Products </h1>
            <Form :action="`/products/${props.product.id}`" method="put">
                    <input type="text" name="name" :placeholder="props.product.name" />
                    <input type="text" name="description" :placeholder="props.product.description" />
                    <Button>Editar</Button>

            </Form>


            


        </div>
    </AppLayout>
</template>
