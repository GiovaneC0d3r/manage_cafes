<script setup lang="ts">
import {
    SidebarGroup,
    SidebarGroupLabel,
    SidebarMenu,
    SidebarMenuSub,
    SidebarMenuSubItem,
    SidebarMenuButton,
    SidebarMenuItem,
} from '@/components/ui/sidebar';
import { Collapsible, CollapsibleTrigger, CollapsibleContent } from '@/components/ui/collapsible';

import { urlIsActive } from '@/lib/utils';
import { type NavItem } from '@/types';
import { Link, usePage } from '@inertiajs/vue3';
import { ChevronRight } from 'lucide-vue-next';

defineProps<{
    items: NavItem[];
}>();

const page = usePage();
</script>
<template>
    <SidebarMenu>
        <template v-for="item in items" :key="item.title">
            <!-- Item com submenu (collapsible) -->
            <Collapsible v-if="item.collapsibleItems" class="group/collapsible">
                <SidebarMenuItem>
                    <CollapsibleTrigger asChild>

                        <SidebarMenuButton>
                            <component :is="item.icon" class="mr-2 w-4 h-4" />
                            {{ item.title }}
                            <ChevronRight class="group-data-[state=open]/collapsible:rotate-90 cursor-pointer  absolute right-2"/> 

                        </SidebarMenuButton>
                          </CollapsibleTrigger>

                    <CollapsibleContent>
                        <SidebarMenuSub>
                            <SidebarMenuSubItem v-for="sub in item.collapsibleItems" :key="sub.title">
                                <SidebarMenuButton as-child>
                                    <Link :href="sub.href">
                                    <component :is="sub.icon" class="mr-2 w-4 h-4" />
                                    {{ sub.title }}
                                    </Link>
                                </SidebarMenuButton>
                            </SidebarMenuSubItem>
                        </SidebarMenuSub>
                    </CollapsibleContent>
                </SidebarMenuItem>
            </Collapsible>

            <!-- Item normal -->
            <SidebarMenuItem v-else>
                <SidebarMenuButton as-child>
                    <Link :href="item.href">
                    <component :is="item.icon" class="mr-2 w-4 h-4" />
                    {{ item.title }}
                    </Link>
                </SidebarMenuButton>
            </SidebarMenuItem>
        </template>
    </SidebarMenu>
</template>
