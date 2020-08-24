namespace juce
{
#if JUCE_DEBUG
 this_will_fail_to_link_if_some_of_your_compile_units_are_built_in_debug_mode
    ::this_will_fail_to_link_if_some_of_your_compile_units_are_built_in_debug_mode() noexcept {}
#else
 this_will_fail_to_link_if_some_of_your_compile_units_are_built_in_release_mode
    ::this_will_fail_to_link_if_some_of_your_compile_units_are_built_in_release_mode() noexcept {}
#endif
}
