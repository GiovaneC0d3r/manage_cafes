<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { dashboard } from '@/routes';
import { type BreadcrumbItem } from '@/types';
import { Head, usePage, Form  } from '@inertiajs/vue3';
import {computed } from 'vue';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Create Products',
        href: '/products/create',
    },
];
</script>

<template>
    <Head title="Criar Produto" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-4">
            <h1>Products </h1>
            <Form action="/products" method="post" class="flex flex-col  gap-2" >
                <Input type="text" name="name"></Input>
                <Input type="text" name="description"></Input>
                
                <Button type="submit">Criar</Button>

            </Form>
        </div>
    </AppLayout>
</template>
