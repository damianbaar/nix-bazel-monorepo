group = "com.example"
packages_group = group + ".packages"

DEP_BLOCK = """
<dependency>
  <groupId>{0}</groupId>
  <artifactId>{1}</artifactId>
  <version>{2}</version>
</dependency>
""".strip()

# in:  //packages/module_a/java:module_a
# out: <dependency>
#         <groupId>com.example.packages</groupId>
#         <artifactId>module_b</artifactId>
#         <version>LOCAL-SNAPSHOT</version>
#     </dependency>
def generate_local_deps(src):
    dep = src[0]
    pathModule = dep.split(":")
    parts = ([packages_group] + [pathModule[1]] + ["LOCAL-SNAPSHOT"])
    return DEP_BLOCK.format(*parts)

# def test(name, **kwargs):
#     """Create a miniature of the src image.

#     The generated file is prefixed with 'small_'.
#     """
#     native.genrule(
#         name = name,
#         # srcs = [src],
#         outs = [name],
#         # outs = [name],
#         cmd = "echo " + name + " > $@",
#         **kwargs
#     )
